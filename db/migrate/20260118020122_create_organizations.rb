class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :logo_url
      t.string :website
      t.string :billing_email
      t.string :stripe_customer_id

      t.timestamps
    end

    add_index :organizations, :slug, unique: true
    add_index :organizations, :stripe_customer_id, unique: true
  end
end
