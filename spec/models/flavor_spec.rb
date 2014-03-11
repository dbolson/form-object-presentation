require 'spec_helper'

describe Flavor do
  describe 'validations' do
    let(:flavor) { described_class.new }

    it 'requires a name' do
      flavor.valid?
      expect(flavor.errors[:name]).to be_present
    end

    it 'requires a unique name' do
      existing = create(:flavor)
      flavor.name = existing.name
      flavor.valid?
      expect(flavor.errors[:name]).to be_present
    end
  end
end
