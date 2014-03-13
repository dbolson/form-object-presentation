require 'spec_helper'

describe NewOrderForm do
  describe 'validations' do
    let(:form) { described_class.new }

    it 'requires a flavor ID' do
      form.valid?
      expect(form.errors[:flavor_id]).to be_present
    end

    it 'requires a serving size ID' do
      form.valid?
      expect(form.errors[:serving_size_id]).to be_present
    end

    it 'requires scoops' do
      form.valid?
      expect(form.errors[:scoops]).to be_present
    end

    it 'requires at least 1 scoop' do
      form.scoops = 0
      form.valid?
      expect(form.errors[:scoops]).to be_present
    end

    it 'cannot have more than 3 scoops' do
      form.scoops = 4
      form.valid?
      expect(form.errors[:scoops]).to be_present
    end
  end

  describe 'when setting topping IDs' do
    let(:form) { described_class.new }

    before do
      expect(Topping).to receive(:exists?).with(1).and_return(true)
      expect(Topping).to receive(:exists?).with(2).and_return(false)

      form.topping_ids = [1, 2]
    end

    it 'does not set non-existent ones' do
      form.valid?
      expect(form.errors[:topping_ids]).to be_present
    end
  end

  describe '#save' do
    let(:form) { described_class.new }

    context 'when valid' do
      before do
        form.attributes = { flavor_id: 1, serving_size_id: 1, scoops: 1 }
      end

      it 'saves the models' do
        expect(OrderCreating).to receive(:call).with(form.attributes)
        form.save
      end
    end

    context 'when invalid' do
      before do
        form.attributes = {}
      end

      it 'does not save' do
        expect(OrderCreating).to_not receive(:call)
        form.save
      end
    end
  end
end
