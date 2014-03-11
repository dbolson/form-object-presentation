require 'spec_helper'

describe ServingSize do
  describe 'validations' do
    let(:serving_size) { described_class.new }

    it 'requires a name' do
      serving_size.valid?
      expect(serving_size.errors[:name]).to be_present
    end

    it 'requires a unique name' do
      existing = create(:serving_size)
      serving_size.name = existing.name
      serving_size.valid?
      expect(serving_size.errors[:name]).to be_present
    end
  end
end
