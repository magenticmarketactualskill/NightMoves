class CreateCommercialLicenses < ActiveRecord::Migration[8.1]
  def change
    create_table :commercial_licenses do |t|
      t.references :component, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :license_key, null: false
      t.integer :status, default: 0, null: false
      t.integer :seats, default: 1
      t.integer :price_cents, null: false
      t.datetime :expires_at

      t.timestamps
    end

    add_index :commercial_licenses, :license_key, unique: true
    add_index :commercial_licenses, :status
  end
end
