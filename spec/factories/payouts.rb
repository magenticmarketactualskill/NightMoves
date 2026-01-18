FactoryBot.define do
  factory :payout do
    developer { nil }
    amount_cents { 1 }
    status { 1 }
    stripe_payout_id { "MyString" }
    period_start { "2026-01-17" }
    period_end { "2026-01-17" }
    paid_at { "2026-01-17 21:01:42" }
  end
end
