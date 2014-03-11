FactoryGirl.define do
  factory :flavor do
    sequence(:name) { |n| "flavor_#{n}" }
  end
end
