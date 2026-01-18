FactoryBot.define do
  factory :component_version do
    component { nil }
    version { "MyString" }
    changelog { "MyText" }
    release_notes { "MyText" }
    package_url { "MyString" }
    checksum { "MyString" }
    min_ruby_version { "MyString" }
    min_rails_version { "MyString" }
    status { 1 }
    downloads_count { 1 }
    published_at { "2026-01-17 21:01:30" }
  end
end
