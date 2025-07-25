class CreateShortUrlMappings < ActiveRecord::Migration[8.0]
  def change
    create_table :short_url_mappings do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :original_url, null: false
      t.references :mappable, polymorphic: true

      t.timestamps
    end
  end
end
