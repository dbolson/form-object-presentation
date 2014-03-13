require 'spec_helper'

describe IceCreamPriceUpdating do
  let(:meme1) { double(:meme, rating: 1) }
  let(:meme2) { double(:meme, rating: 10) }
  let(:ice_cream) { double(:ice_cream, price: 100, memes: [meme1, meme2]) }

  describe '.call' do
    it 'updates the ice cream price based on the scoops and meme ratings' do
      expect(ice_cream).to receive(:update_attributes!).with(price: 111)
      described_class.call(ice_cream)
    end
  end
end
