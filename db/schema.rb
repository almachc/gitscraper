# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_26_231212) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.string "username", null: false
    t.string "github_url", null: false
    t.string "avatar_url", null: false
    t.integer "followers_count", null: false
    t.integer "following_count", null: false
    t.integer "stars_count", null: false
    t.integer "contributions_12mo_count", null: false
    t.string "organization"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('portuguese'::regconfig, (COALESCE(location, ''::character varying))::text)", name: "profiles_location_fts_index", using: :gin
    t.index "to_tsvector('portuguese'::regconfig, (COALESCE(name, ''::character varying))::text)", name: "profiles_name_fts_index", using: :gin
    t.index "to_tsvector('portuguese'::regconfig, (COALESCE(organization, ''::character varying))::text)", name: "profiles_organization_fts_index", using: :gin
    t.index ["github_url"], name: "profiles_github_url_trgm_index", opclass: :gin_trgm_ops, using: :gin
    t.index ["username"], name: "index_profiles_on_username", unique: true
    t.index ["username"], name: "profiles_username_trgm_index", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "short_url_mappings", force: :cascade do |t|
    t.string "code", null: false
    t.string "original_url", null: false
    t.string "mappable_type"
    t.bigint "mappable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_short_url_mappings_on_code", unique: true
    t.index ["mappable_type", "mappable_id"], name: "index_short_url_mappings_on_mappable"
  end
end
