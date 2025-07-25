class ShortUrlMappingsController < ApplicationController
  ALLOWED_HOSTS = [ 'github.com' ]

  def redirect
    short_url_mapping = ShortUrlMapping.find_by!(code: params[:code])
    uri = URI.parse(short_url_mapping.original_url)

    unless uri.is_a?(URI::HTTPS) && ALLOWED_HOSTS.include?(uri.host)
      head :unprocessable_entity
      return
    end

    redirect_to uri.to_s, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render plain: t('.url_not_found'), status: :not_found
  rescue URI::InvalidURIError
    head :unprocessable_entity
  end
end
