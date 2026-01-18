class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :plan, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.string :stripe_subscription_id
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :canceled_at

      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
    add_index :subscriptions, :status
  end
end
