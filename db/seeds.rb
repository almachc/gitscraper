profile1 = Profile.find_or_create_by!(username: 'homerdev') do |profile|
  profile.name = 'Homer Simpsons'
  profile.github_url = 'https://github.com/matz'
  profile.avatar_url = 'https://avatars.githubusercontent.com/u/3301'
  profile.followers_count = 50
  profile.following_count = 30
  profile.stars_count = 12
  profile.contributions_12mo_count = 247
  profile.organization = 'Google'
  profile.location = 'Springfield, USA'
end

profile2 = Profile.find_or_create_by!(username: 'peterdev') do |profile|
  profile.name = 'Peter Griffin'
  profile.github_url = 'https://github.com/akitaonrails'
  profile.avatar_url = 'https://avatars.githubusercontent.com/u/5525'
  profile.followers_count = 200
  profile.following_count = 250
  profile.stars_count = 15
  profile.contributions_12mo_count = 230
  profile.organization = ''
  profile.location = ''
end

ShortUrlMapping.find_or_create_by!(mappable: profile1) do |short_url_mapping|
  short_url_mapping.original_url = profile1.github_url
end

ShortUrlMapping.find_or_create_by!(mappable: profile2) do |short_url_mapping|
  short_url_mapping.original_url = profile2.github_url
end
