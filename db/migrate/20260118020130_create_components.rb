class CreateComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :components do |t|
      t.references :developer, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.string :slug, null: false
      t.string :tagline
      t.text :description
      t.text :readme
      t.string :repository_url
      t.string :documentation_url
      t.references :category, foreign_key: true
      t.integer :license_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.integer :downloads_count, default: 0
      t.integer :stars_count, default: 0
      t.integer :commercial_price_cents
      t.boolean :featured, default: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :components, :slug, unique: true
    add_index :components, :status
    add_index :components, :featured
    add_index :components, :published_at
  end
end
