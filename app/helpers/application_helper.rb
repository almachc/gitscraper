module ApplicationHelper
  def render_short_link(mapping)
    return unless mapping&.short_url

    link_to mapping.short_url, mapping.short_url, target: '_blank', rel: 'noopener'
  end
end
