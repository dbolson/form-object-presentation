class NewOrderForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :flavor_id, Integer
  attribute :serving_size_id, Integer
  attribute :scoops, Integer
  attribute :topping_ids, Array[Integer]

  attr_reader :model

  validates :flavor_id, :serving_size_id, presence: true
  validates :scoops, presence: true, inclusion: { in: [1, 2, 3] }
  validate :more_scoops_than_toppings

  # does not persist for Rails form helper
  def persisted?
    false
  end

  # delegate to model for Rails named routes
  def to_param
    model.to_param
  end

  def topping_ids=(toppings)
    filtered_toppings = toppings.reject { |t| !Topping.exists?(t) }
    super(filtered_toppings)
  end

  def save
    if valid?
      persist
      true
    else
      false
    end
  end

  private

  def persist
    @model = OrderCreating.call(attributes)
  end

  def more_scoops_than_toppings
    if scoops.to_i < topping_ids.delete_if { |attr| attr == '' }.size
      errors.add(:topping_ids, "can't be more than scoops")
    end
  end
end
