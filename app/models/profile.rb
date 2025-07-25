class Profile < ApplicationRecord
  has_one :short_url_mapping, as: :mappable, dependent: :destroy

  validates :name, :username, :github_url, :avatar_url, :followers_count, :following_count,
            :stars_count, :contributions_12mo_count, presence: true

  validates :username, uniqueness: true

  after_create :create_associated_url_mapping!
  after_update :update_associated_url_mapping!, if: :saved_change_to_github_url?

  private

  def create_associated_url_mapping!
    create_short_url_mapping!(original_url: github_url)
  end

  def update_associated_url_mapping!
    short_url_mapping&.update!(original_url: github_url)
  end
end
