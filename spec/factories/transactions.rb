FactoryBot.define do
  factory :transaction do
    commercial_license { nil }
    subscription { nil }
    organization { nil }
    amount_cents { 1 }
    platform_fee_cents { 1 }
    developer_payout_cents { 1 }
    currency { "MyString" }
    status { 1 }
    stripe_payment_intent_id { "MyString" }
    stripe_transfer_id { "MyString" }
    transaction_type { 1 }
  end
end
