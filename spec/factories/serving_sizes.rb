FactoryGirl.define do
  factory :serving_size do
    sequence(:name) { |n| "serving_size_#{n}" }
  end
end
