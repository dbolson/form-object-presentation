class IceCream < ActiveRecord::Base
  belongs_to :flavor
  belongs_to :serving_size
  has_and_belongs_to_many :toppings
  has_many :memes, dependent: :destroy
end
