class ShortUrlMappingsController < ApplicationController
  def redirect
    short_url_mapping = ShortUrlMapping.find_by!(code: params[:code])
    redirect_to short_url_mapping.original_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render plain: t('.url_not_found'), status: :not_found
  end
end
