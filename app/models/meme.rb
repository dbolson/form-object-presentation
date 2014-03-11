class Meme < ActiveRecord::Base
  belongs_to :ice_cream

  validates :ice_cream, presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :ice_cream }
  validates :rating,
            presence: true,
            inclusion: { in: 1..10, message: 'must be between 1 and 10' }

  def self.create_defaults(ice_cream)
    defaults.each do |name|
      ice_cream.memes.create!(name: name, rating: 8)
    end
  end

  def self.defaults
    ['Chocolate Rain', 'Much Delicious. Wow.']
  end
end
