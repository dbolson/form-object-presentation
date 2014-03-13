class IceCreamPriceUpdating
  def self.call(ice_cream)
    new(ice_cream).call
  end

  def initialize(ice_cream)
    @ice_cream = ice_cream
  end

  def call
    meme_ratings = ice_cream.memes.reduce(0) { |sum, meme| sum += meme.rating }
    ice_cream.update_attributes!(price: ice_cream.price + meme_ratings)
    ice_cream
  end

  private

  attr_reader :ice_cream
end
