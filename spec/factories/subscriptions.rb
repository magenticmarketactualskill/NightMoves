FactoryBot.define do
  factory :subscription do
    organization { nil }
    plan { 1 }
    status { 1 }
    stripe_subscription_id { "MyString" }
    current_period_start { "2026-01-17 21:01:36" }
    current_period_end { "2026-01-17 21:01:36" }
    canceled_at { "2026-01-17 21:01:36" }
  end
end
