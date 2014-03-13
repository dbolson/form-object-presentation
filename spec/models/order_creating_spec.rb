require 'spec_helper'

describe OrderCreating do
  describe '.call' do
    let(:attributes) {{
      flavor_id: 1,
      serving_size_id: 1,
      topping_ids: [1],
      scoops: 1
    }}
    let(:ice_cream) { double(:ice_cream) }

    before do
      allow(IceCream).to receive(:transaction).and_yield
      allow(IceCream).to receive(:create!).and_return(ice_cream)
      allow(Meme).to receive(:create_defaults)
      allow(IceCreamPriceUpdating).to receive(:call).with(ice_cream).and_return(ice_cream)
    end

    it 'saves the ice cream' do
      expect(IceCream).to receive(:create!)
        .with(flavor_id: 1, serving_size_id: 1, topping_ids: [1], scoops: 1, price: 100)
      described_class.call(attributes)
    end

    it 'creates default memes' do
      expect(Meme).to receive(:create_defaults).with(ice_cream)
      described_class.call(attributes)
    end

    it 'updates the ice cream price' do
      expect(IceCreamPriceUpdating).to receive(:call).with(ice_cream)
      described_class.call(attributes)
    end

    it 'returns the ice cream' do
      expect(described_class.call(attributes)).to eq(ice_cream)
    end
  end
end
