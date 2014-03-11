class Topping < ActiveRecord::Base
  has_and_belongs_to_many :ice_creams

  validates :name,
            presence: true,
            uniqueness: true
end
