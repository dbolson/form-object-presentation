class IceCream < ActiveRecord::Base
  belongs_to :flavor
  belongs_to :serving_size
  has_and_belongs_to_many :toppings
  has_many :memes, dependent: :destroy

  accepts_nested_attributes_for :memes,
                                reject_if: proc { |attr|
                                  attr['name'].blank? || attr['rating'].blank?
                                },
                                allow_destroy: true

  validates :flavor_id, presence: true
  validates :serving_size_id, presence: true
  validates :scoops,
            presence: true,
            inclusion: { in: [1, 2, 3] }
  validate :more_scoops_than_toppings

  before_save :set_price

  def topping_ids=(toppings)
    filtered_toppings = toppings.reject { |t| !Topping.exists?(t) }
    super(filtered_toppings)
  end

  def ratings_sum
    memes.reduce(0) { |memo, meme| memo += meme.rating }
  end

  private

  def more_scoops_than_toppings
    if scoops.to_i < toppings.size
      errors.add(:toppings, "can't be more than scoops")
    end
  end

  def set_price
    unless price_changed?
      self.price = scoops * 100
    end
  end
end
