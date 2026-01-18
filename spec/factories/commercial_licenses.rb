FactoryBot.define do
  factory :commercial_license do
    component { nil }
    organization { nil }
    license_key { "MyString" }
    status { 1 }
    seats { 1 }
    price_cents { 1 }
    expires_at { "2026-01-17 21:01:37" }
  end
end
