require 'rails_helper'

RSpec.describe Github::ProfileScraper do
  describe '.call' do
    let(:github_url) { 'https://github.com/homerdev' }
    let(:github_response) { File.read('spec/fixtures/github_profile.html') }
    let(:contributions_url) { 'https://github.com/homerdev?tab=contributions' }

    context 'when successful' do
      let(:contributions_response) { File.read('spec/fixtures/github_contributions.html') }

      before do
        stub_request(:get, github_url).to_return(status: 200, body: github_response)

        stub_request(:get, contributions_url)
          .with(headers: { 'X-Requested-With' => 'XMLHttpRequest' })
          .to_return(status: 200, body: contributions_response)
      end

      it 'returns an object with github perfil data' do
        result = described_class.call(github_url)

        expect(result.success?).to be_truthy
        expect(result.data).to include(
          username: 'homerdev',
          followers_count: '25',
          following_count: '30',
          organization: 'Google',
          location: 'Springfield, USA',
          stars_count: '12',
          avatar_url: 'https://avatars.githubusercontent.com/u/3301',
          contributions_12mo_count: 247
        )
      end
    end

    context 'when github url is not provided' do
      let(:github_url) { '' }

      it 'returns a failure object' do
        result = described_class.call(github_url)

        expect(result).not_to be_success
        expect(result.error).to eq(:missing_github_url)
      end
    end

    context 'when expected elements are not found in the HTML' do
      let(:github_response) { "<html><body><h1>No information</h1></body></html>" }

      before do
        stub_request(:get, github_url).to_return(status: 200, body: github_response)
      end

      it 'returns a failure object' do
        result = described_class.call(github_url)

        expect(result.success?).not_to be true
        expect(result.error).to eq(:scraped_data_missing)
      end
    end

    context 'when profile request is 404' do
      before { stub_request(:get, github_url).to_return(status: 404) }

      it 'returns a failure object' do
        result = described_class.call(github_url)

        expect(result).not_to be_success
        expect(result.error).to eq(:profile_not_found)
      end
    end

    context 'when contributions request fails' do
      let(:any_error_status) { 406 }

      before do
        stub_request(:get, github_url).to_return(status: 200, body: github_response)
        stub_request(:get, contributions_url).to_return(status: any_error_status)
      end

      it 'returns a failure object' do
        result = described_class.call(github_url)

        expect(result.success?).not_to be true
        expect(result.error).to eq(:scraped_data_missing)
      end
    end

    context 'when a connection error is raised' do
      before do
        stub_request(:get, github_url).to_timeout
      end

      it 'returns a failure object' do
        result = described_class.call(github_url)

        expect(result).not_to be_success
        expect(result.error).to eq(:unexpected_error)
      end
    end
  end
end
