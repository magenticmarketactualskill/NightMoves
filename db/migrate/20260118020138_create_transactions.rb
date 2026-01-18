class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :commercial_license, foreign_key: true
      t.references :subscription, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.integer :platform_fee_cents
      t.integer :developer_payout_cents
      t.string :currency, default: "usd", null: false
      t.integer :status, default: 0, null: false
      t.string :stripe_payment_intent_id
      t.string :stripe_transfer_id
      t.integer :transaction_type, default: 0, null: false

      t.timestamps
    end

    add_index :transactions, :stripe_payment_intent_id
    add_index :transactions, :status
    add_index :transactions, :transaction_type
  end
end
