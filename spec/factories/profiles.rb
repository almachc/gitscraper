FactoryBot.define do
  factory :profile do
    name { 'Homer Simpsons' }
    username { 'homerdev' }
    github_url { 'https://github.com/homerdev' }
    avatar_url { 'https://avatars.githubusercontent.com/u/12345678' }
    followers_count { 25 }
    following_count { 30 }
    stars_count { 12 }
    contributions_12mo_count { 126 }
    organization { 'Google' }
    location { 'Springfield, USA' }
  end
end
