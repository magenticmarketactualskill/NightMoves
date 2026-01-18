FactoryBot.define do
  factory :component do
    developer { nil }
    name { "MyString" }
    slug { "MyString" }
    tagline { "MyString" }
    description { "MyText" }
    readme { "MyText" }
    repository_url { "MyString" }
    documentation_url { "MyString" }
    category { nil }
    license_type { 1 }
    status { 1 }
    downloads_count { 1 }
    stars_count { 1 }
    commercial_price_cents { 1 }
    featured { false }
    published_at { "2026-01-17 21:01:30" }
  end
end
