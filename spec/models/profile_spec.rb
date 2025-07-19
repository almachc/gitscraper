require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject { build(:profile) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:github_url) }
    it { should validate_presence_of(:avatar_url) }
    it { should validate_presence_of(:followers_count) }
    it { should validate_presence_of(:following_count) }
    it { should validate_presence_of(:stars_count) }
    it { should validate_presence_of(:contributions_12mo_count) }
    it { should validate_uniqueness_of(:username) }
  end
end
