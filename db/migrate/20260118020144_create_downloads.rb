class CreateDownloads < ActiveRecord::Migration[8.1]
  def change
    create_table :downloads do |t|
      t.references :component_version, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :downloads, :created_at
  end
end
