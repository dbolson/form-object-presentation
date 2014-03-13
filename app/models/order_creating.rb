class OrderCreating
  def self.call(attributes={})
    new(attributes).call
  end

  def initialize(attributes)
    @flavor_id = attributes.fetch(:flavor_id)
    @serving_size_id = attributes.fetch(:serving_size_id)
    @topping_ids = attributes.fetch(:topping_ids)
    @scoops = attributes.fetch(:scoops)
  end

  def call
    IceCream.transaction do
      ice_cream = IceCream.create!(flavor_id: flavor_id,
                                   serving_size_id: serving_size_id,
                                   topping_ids: topping_ids,
                                   scoops: scoops,
                                   price: scoops * 100)

      Meme.create_defaults(ice_cream)
      IceCreamPriceUpdating.call(ice_cream)
      ice_cream
    end
  end

  private

  attr_reader :flavor_id,
              :serving_size_id,
              :topping_ids,
              :scoops
end
