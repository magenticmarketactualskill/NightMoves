FactoryBot.define do
  factory :category do
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    icon { "MyString" }
    parent { nil }
    position { 1 }
    components_count { 1 }
  end
end
