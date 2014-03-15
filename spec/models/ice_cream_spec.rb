require 'spec_helper'

describe IceCream do
  let(:ice_cream) { described_class.new }

  describe 'validations' do
    it 'requires a flavor' do
      ice_cream.valid?
      expect(ice_cream.errors[:flavor_id]).to be_present
    end

    it 'requires a serving size' do
      ice_cream.valid?
      expect(ice_cream.errors[:serving_size_id]).to be_present
    end

    it 'requires scoops' do
      ice_cream.valid?
      expect(ice_cream.errors[:scoops]).to be_present
    end

    it 'cannot have 0 scoops' do
      ice_cream.scoops = 0
      ice_cream.valid?
      expect(ice_cream.errors[:scoops]).to be_present
    end

    it 'cannot have more than 3 scoops' do
      ice_cream.scoops = 4
      ice_cream.valid?
      expect(ice_cream.errors[:scoops]).to be_present
    end

    it 'cannot have more toppings than scoops' do
      topping1 = create(:topping)
      topping2 = create(:topping)
      ice_cream.scoops = 1
      ice_cream.topping_ids = [topping1.id, topping2.id]
      ice_cream.valid?
      expect(ice_cream.errors[:toppings]).to be_present
    end
  end

  it 'does not set toppings that do not exist' do
    ice_cream.topping_ids = [-1]
    expect(ice_cream.topping_ids).to be_empty
  end

  describe 'before saving' do
    let(:ice_cream) { build_stubbed(:ice_cream, scoops: 2) }

    before do
      ice_cream.price = 50
      ice_cream.save!
    end

    context 'when the price changed' do
      it 'keeps the price the same' do
        expect(ice_cream.price).to eq(50)
      end
    end

    context 'when the price has not changed' do
      before do
        ice_cream.save!
      end

      it 'sets the price based on the scoops' do
        expect(ice_cream.price).to eq(200)
      end
    end
  end
end
