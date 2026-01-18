FactoryBot.define do
  factory :download do
    component_version { nil }
    user { nil }
    organization { nil }
    ip_address { "MyString" }
    user_agent { "MyString" }
  end
end
