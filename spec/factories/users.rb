FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    campaigns_list { [{campaign_name: Faker::Name.name, campaign_id: rand(1000)}] }
  end
end
