FactoryBot.define do
  factory :organization do
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    logo_url { "MyString" }
    website { "MyString" }
    billing_email { "MyString" }
    stripe_customer_id { "MyString" }
  end
end
