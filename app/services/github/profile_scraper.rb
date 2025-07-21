module Github
  class ProfileScraper < ApplicationService
    BASE_URL = 'https://github.com'

    ELEMENTS_WITH_TEXT_EXTRACTION = {
      username: 'div[itemtype="http://schema.org/Person"] span[itemprop="additionalName"]',
      followers_count: 'div[itemtype="http://schema.org/Person"] a[href*="tab=followers"] > span',
      following_count: 'div[itemtype="http://schema.org/Person"] a[href*="tab=following"] > span',
      organization: 'div[itemtype="http://schema.org/Person"] li[itemprop="worksFor"] div',
      location: 'div[itemtype="http://schema.org/Person"] li[itemprop="homeLocation"] span',
      stars_count: 'a[data-tab-item="stars"] span.Counter'
    }

    def initialize(github_url)
      @github_url = github_url
    end

    def call
      return failure_result(:missing_github_url) if @github_url.blank?

      document = fetch_html_document(@github_url)

      profile_data = extract_text_from_elements(document).merge(
        avatar_url: extract_avatar_url(document),
        contributions_count: extract_contributions(document)
      )

      success_result(profile_data)
    rescue Faraday::ResourceNotFound
      failure_result(:profile_not_found)
    rescue Faraday::Error
      failure_result(:unexpected_error)
    end

    private

    def extract_text_from_elements(doc)
      ELEMENTS_WITH_TEXT_EXTRACTION.transform_values do |selector|
        doc.at_css(selector)&.text&.strip
      end
    end

    def extract_avatar_url(doc)
      doc.at_css('div[itemtype="http://schema.org/Person"] a[itemprop="image"]')&.[]('href')
    end

    def extract_contributions(doc)
      relative_path = doc.at_css('include-fragment[src*="tab=contributions"]')&.[]('src')
      return nil if relative_path.blank?

      url = "#{BASE_URL}#{relative_path}"
      document = fetch_html_document(url, { 'X-Requested-With' => 'XMLHttpRequest' })

      document.at_css('h2#js-contribution-activity-description')&.text[/\d+/]&.to_i
    rescue Faraday::Error
      nil
    end

    def fetch_html_document(url, headers = {})
      response = Faraday.get(url, nil, headers)

      Nokogiri::HTML(response.body)
    end
  end
end
