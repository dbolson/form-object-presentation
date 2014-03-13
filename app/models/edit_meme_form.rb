class EditMemeForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :id, Integer
  attribute :name, String
  attribute :rating, Integer
  attribute :_destroy, Boolean, default: false

  validates :name, presence: true
  validates :rating,
            presence: true,
            inclusion: { in: 1..10, message: 'must be between 1 and 10' }
end
