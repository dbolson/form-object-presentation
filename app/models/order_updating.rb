class OrderUpdating
  def self.call(ice_cream, attributes={})
    new(ice_cream, attributes).call
  end

  def initialize(ice_cream, attributes)
    @ice_cream = ice_cream
    @flavor_id = attributes.fetch(:flavor_id)
    @serving_size_id = attributes.fetch(:serving_size_id)
    @topping_ids = attributes.fetch(:topping_ids)
    @scoops = attributes.fetch(:scoops)
    @memes = attributes.fetch(:memes)
  end

  def call
    IceCream.transaction do
      ice_cream.update_attributes!(flavor_id: flavor_id,
                                   serving_size_id: serving_size_id,
                                   topping_ids: topping_ids,
                                   scoops: scoops,
                                   price: scoops * 100)

      memes.each do |meme|
        if meme._destroy
          Meme.destroy(meme.id)
        elsif meme.id
          Meme.find(meme.id).update_attributes!(updating_attributes(meme))
        else
          Meme.create!(updating_attributes(meme).merge(ice_cream: ice_cream))
        end
      end

      ice_cream
    end
  end

  private

  attr_reader :ice_cream,
              :flavor_id,
              :serving_size_id,
              :topping_ids,
              :scoops,
              :memes

  def updating_attributes(meme)
    meme.attributes.keep_if { |attribute| [:name, :rating].include?(attribute) }
  end
end
