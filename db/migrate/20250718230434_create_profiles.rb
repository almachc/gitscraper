class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.string :username, null: false, index: { unique: true }
      t.string :github_url, null: false
      t.string :avatar_url, null: false
      t.integer :followers_count, null: false
      t.integer :following_count, null: false
      t.integer :stars_count, null: false
      t.integer :contributions_12mo_count, null: false
      t.string :organization
      t.string :location

      t.timestamps
    end
  end
end
