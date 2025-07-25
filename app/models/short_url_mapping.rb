class ShortUrlMapping < ApplicationRecord
  belongs_to :mappable, polymorphic: true

  validates :code, uniqueness: true
  validates :original_url, presence: true

  before_create :generate_code

  def short_url
    Rails.application.routes.url_helpers.short_redirect_url(code)
  end

  private

  def generate_code
    self.code ||= loop do
      code = SecureRandom.alphanumeric(6)
      break code unless ShortUrlMapping.exists?(code: code)
    end
  end
end
