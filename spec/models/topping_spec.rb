require 'spec_helper'

describe Topping do
  describe 'relationships' do
    it 'has many ice creams' do
      expect(described_class.new).to respond_to(:ice_creams)
    end
  end

  describe 'validations' do
    let(:topping) { described_class.new }

    it 'requires a name' do
      topping.valid?
      expect(topping.errors[:name]).to be_present
    end

    it 'requires a unique name' do
      existing = create(:topping)
      topping.name = existing.name
      topping.valid?
      expect(topping.errors[:name]).to be_present
    end
  end
end
