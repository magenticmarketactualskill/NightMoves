class CreateComponentVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :component_versions do |t|
      t.references :component, null: false, foreign_key: true
      t.string :version, null: false
      t.text :changelog
      t.text :release_notes
      t.string :package_url
      t.string :checksum
      t.string :min_ruby_version
      t.string :min_rails_version
      t.integer :status, default: 0, null: false
      t.integer :downloads_count, default: 0
      t.datetime :published_at

      t.timestamps
    end

    add_index :component_versions, [:component_id, :version], unique: true
    add_index :component_versions, :status
  end
end
