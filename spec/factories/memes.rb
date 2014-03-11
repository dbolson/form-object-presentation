FactoryGirl.define do
  factory :meme do
    ice_cream
    sequence(:name) { |n| "meme_#{n}" }
    rating 5
  end
end
