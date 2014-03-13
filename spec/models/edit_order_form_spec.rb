require 'spec_helper'

describe EditOrderForm do
  let(:meme) { create(:meme) }
  let(:ice_cream) {
    create(:ice_cream,
           toppings: [create(:topping)],
           memes: [meme])
  }

  describe '#initialize' do
    let(:form) { described_class.new(ice_cream) }

    it "sets the attributes as the model's" do
      expect(form.attributes[:flavor_id]).to eq(ice_cream.flavor_id)
      expect(form.attributes[:serving_size_id]).to eq(ice_cream.serving_size_id)
      expect(form.attributes[:scoops]).to eq(ice_cream.scoops)
      expect(form.attributes[:topping_ids]).to eq(ice_cream.topping_ids)
    end

    it "sets the meme attributes as the model's" do
      expect(form.attributes[:memes][0].attributes.keys).to eq([:id, :name, :rating, :_destroy])
    end

    it "sets 3 memes" do
      expect(form.attributes[:memes].size).to eq(3)
    end
  end

  describe 'validations' do
    let(:params) {{
      flavor_id: nil,
      serving_size_id: nil,
      scoops: nil
    }}
    let(:form) { described_class.new(ice_cream, params) }

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

    it 'requires a name and rating for a meme' do
      form.memes = [{ name: '', rating: '' }]
      form.valid?
      expect(form.errors[:name].to_a).to be_present
      expect(form.errors[:rating].to_a).to be_present
    end
  end

  describe 'when setting topping IDs' do
    let(:params) {{
      flavor_id: nil,
      serving_size_id: nil,
      scoops: nil
    }}
    let(:form) { described_class.new(ice_cream, params) }

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
    let(:form) { described_class.new(ice_cream) }

    context 'when valid' do
      before do
        form.attributes = {
          flavor_id: 1, serving_size_id: 1, scoops: 1, memes: [{ name: '', rating: '' }]
        }
      end

      it 'saves the models' do
        expect(OrderUpdating).to receive(:call).with(ice_cream, form.attributes)
        form.save
      end
    end

    context 'when invalid' do
      before do
        form.attributes = { flavor_id: nil, memes: [{ name: '', rating: '' }]}
      end

      it 'does not save' do
        expect(OrderUpdating).to_not receive(:call)
        form.save
      end

      it 'sets 3 blank memes' do
        form.save
        expect(form.memes.size).to eq(3)
      end
    end
  end
end
