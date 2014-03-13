require 'spec_helper'

describe OrderUpdating do
  describe '.call' do
    let(:attributes) {{
      flavor_id: 1,
      serving_size_id: 1,
      topping_ids: [1],
      scoops: 1,
      memes: memes
    }}
    let(:ice_cream) { double(:ice_cream) }
    let(:memes) { [] }

    before do
      allow(IceCream).to receive(:transaction).and_yield
      allow(ice_cream).to receive(:update_attributes!)
      allow(Meme).to receive(:create_defaults)
      allow(IceCreamPriceUpdating).to receive(:call).with(ice_cream).and_return(ice_cream)
    end

    it 'saves the ice cream' do
      expect(ice_cream).to receive(:update_attributes!)
        .with(flavor_id: 1, serving_size_id: 1, topping_ids: [1], scoops: 1, price: 100)
      described_class.call(ice_cream, attributes)
    end

    context 'with a meme to delete' do
      let(:memes) { [double(:meme, id: 10, _destroy: '1')] }

      it 'delets the meme' do
        expect(Meme).to receive(:destroy).with(10)
        described_class.call(ice_cream, attributes)
      end
    end

    context 'with a meme to update' do
      let(:meme) {
        double(:meme,
               id: 10,
               _destroy: nil,
               attributes: { name: 'my name', rating: 10 })
      }
      let(:memes) { [meme] }

      it 'updates the meme' do
        expect(Meme).to receive(:find).with(10).and_return(meme)
        expect(meme).to receive(:update_attributes!).with(name: 'my name', rating: 10)
        described_class.call(ice_cream, attributes)
      end
    end

    context 'with a new meme' do
      let(:meme) {
        double(:meme,
               id: nil,
               _destroy:
               nil,
               attributes: { name: 'my name', rating: 10 })
      }
      let(:memes) { [meme] }

      it 'creates the meme' do
        expect(Meme).to receive(:create!).with(name: 'my name', rating: 10, ice_cream: ice_cream)
        described_class.call(ice_cream, attributes)
      end
    end

    it 'updates the ice cream price' do
      expect(IceCreamPriceUpdating).to receive(:call).with(ice_cream)
      described_class.call(ice_cream, attributes)
    end

    it 'returns the ice cream' do
      expect(described_class.call(ice_cream, attributes)).to eq(ice_cream)
    end
  end
end
