class Profile < ApplicationRecord
  validates :name, :username, :github_url, :avatar_url, :followers_count, :following_count,
            :stars_count, :contributions_12mo_count, presence: true

  validates :username, uniqueness: true
end
