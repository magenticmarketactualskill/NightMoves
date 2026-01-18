class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :component, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :title
      t.text :body
      t.integer :helpful_count, default: 0

      t.timestamps
    end

    add_index :reviews, [:component_id, :user_id], unique: true
    add_index :reviews, :rating
  end
end
