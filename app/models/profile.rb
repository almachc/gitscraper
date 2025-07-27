class Profile < ApplicationRecord
  SEARCH_SCOPES = {
    'name' => ->(term) { by_name(term) },
    'username' => ->(term) { by_username(term) },
    'organization' => ->(term) { by_organization(term) },
    'location' => ->(term) { by_location(term) },
    'github_url' => ->(term) { by_github_url(term) }
  }

  has_one :short_url_mapping, as: :mappable, dependent: :destroy

  validates :name, :username, :github_url, :avatar_url, :followers_count, :following_count,
            :stars_count, :contributions_12mo_count, presence: true

  validates :username, uniqueness: true

  after_create :create_associated_url_mapping!
  after_update :update_associated_url_mapping!, if: :saved_change_to_github_url?

  scope :by_name, ->(term) {
    where("to_tsvector('portuguese', name) @@ to_tsquery('portuguese', ?)", term)
  }

  scope :by_location, ->(term) {
    where("to_tsvector('portuguese', location) @@ to_tsquery('portuguese', ?)", term)
  }

  scope :by_organization, ->(term) {
    where("to_tsvector('portuguese', organization) @@ to_tsquery('portuguese', ?)", term)
  }

  scope :by_username, ->(term) { where("username ILIKE ?", "%#{term}%") }
  scope :by_github_url, ->(term) { where("github_url ILIKE ?", "%#{term}%") }

  def self.search(field: nil, term: nil)
    return Profile.all if term.blank?

    scope = Profile::SEARCH_SCOPES[field]
    return Profile.none unless scope

    scope.call(term)
  end

  private

  def create_associated_url_mapping!
    create_short_url_mapping!(original_url: github_url)
  end

  def update_associated_url_mapping!
    short_url_mapping&.update!(original_url: github_url)
  end
end
