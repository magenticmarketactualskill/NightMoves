FactoryBot.define do
  factory :review do
    component { nil }
    user { nil }
    rating { 1 }
    title { "MyString" }
    body { "MyText" }
    helpful_count { 1 }
  end
end
