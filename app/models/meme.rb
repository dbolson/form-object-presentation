class Meme < ActiveRecord::Base
  belongs_to :ice_cream

  def self.create_defaults(ice_cream)
    defaults.each do |name|
      ice_cream.memes.create!(name: name, rating: 8)
    end
  end

  def self.defaults
    ['Chocolate Rain', 'Much Delicious. Wow.']
  end
end
