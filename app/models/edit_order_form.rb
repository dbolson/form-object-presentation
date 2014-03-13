class EditOrderForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :flavor_id, Integer
  attribute :serving_size_id, Integer
  attribute :scoops, Integer
  attribute :topping_ids, Array[Integer]
  attribute :memes, Array[EditMemeForm]

  attr_reader :model

  validates :flavor_id, :serving_size_id, presence: true
  validates :scoops, presence: true, inclusion: { in: [1, 2, 3] }
  validate :more_scoops_than_toppings
  validate :valid_memes?

  def initialize(model=nil, args={})
    @model = model
    super(build_initial_args(args))
    build_memes
  end

  # persists for Rails form helper
  def persisted?
    true
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
    filter_memes!

    if valid?
      persist
      true
    else
      build_memes
      false
    end
  end

  private

  def build_memes
    (3 - memes.size).times { memes << Meme.new }
  end

  def build_initial_args(args)
    if args.empty?
      args = model.attributes
      args[:topping_ids] = model.topping_ids
    end
    args[:memes] ||= model.memes.map(&:attributes)
    args
  end

  def valid_memes?
    memes.each do |meme|
      unless meme.valid?
        meme.errors.each do |error, message|
          errors.add(error, message)
        end
      end
    end
  end

  def filter_memes!
    memes.delete_if { |meme| meme['name'].blank? && meme['rating'].blank? }
  end

  def more_scoops_than_toppings
    if scoops.to_i < topping_ids.delete_if { |x| x == '' }.size
      errors.add(:topping_ids, "can't be more than scoops")
    end
  end

  def persist
    @model = OrderUpdating.call(@model, attributes)
  end
end
