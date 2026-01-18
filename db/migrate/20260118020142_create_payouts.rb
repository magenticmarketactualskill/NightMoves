class CreatePayouts < ActiveRecord::Migration[8.1]
  def change
    create_table :payouts do |t|
      t.references :developer, null: false, foreign_key: { to_table: :users }
      t.integer :amount_cents, null: false
      t.integer :status, default: 0, null: false
      t.string :stripe_payout_id
      t.date :period_start, null: false
      t.date :period_end, null: false
      t.datetime :paid_at

      t.timestamps
    end

    add_index :payouts, :stripe_payout_id, unique: true
    add_index :payouts, :status
  end
end
