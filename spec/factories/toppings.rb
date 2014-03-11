FactoryGirl.define do
  factory :topping do
    sequence(:name) { |n| "topping_#{n}" }
  end
end
