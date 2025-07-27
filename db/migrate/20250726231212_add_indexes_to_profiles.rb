class AddIndexesToProfiles < ActiveRecord::Migration[8.0]
  def up
    add_index :profiles,
              "to_tsvector('portuguese', coalesce(name, ''))",
              using: :gin,
              name: 'profiles_name_fts_index'

    add_index :profiles,
              "to_tsvector('portuguese', coalesce(location, ''))",
              using: :gin,
              name: 'profiles_location_fts_index'

    add_index :profiles,
              "to_tsvector('portuguese', coalesce(organization, ''))",
              using: :gin,
              name: 'profiles_organization_fts_index'

    add_index :profiles,
              :username,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: 'profiles_username_trgm_index'

    add_index :profiles,
              :github_url,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: 'profiles_github_url_trgm_index'
  end

  def down
    remove_index :profiles, name: 'profiles_name_fts_index'
    remove_index :profiles, name: 'profiles_location_fts_index'
    remove_index :profiles, name: 'profiles_organization_fts_index'
    remove_index :profiles, name: 'profiles_username_trgm_index'
    remove_index :profiles, name: 'profiles_github_url_trgm_index'
  end
end
