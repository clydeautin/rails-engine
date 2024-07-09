FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    unit_price { rand(100..10000) }
    description { Faker::Lorem.sentences(number: 1) }
    association :merchant
  end
end