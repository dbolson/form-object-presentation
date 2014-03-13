require 'spec_helper'

describe Meme do
  describe 'relationships' do
    it 'belongs to an ice cream' do
      expect(described_class.new).to respond_to(:ice_cream)
    end
  end

  describe '.create_defaults' do
    let(:ice_cream) { create(:ice_cream) }

    it 'sets the default memes for the ice cream' do
      described_class.create_defaults(ice_cream)
      expect(ice_cream.memes.map(&:name)).to eq(Meme.defaults.reverse)
    end
  end

  describe '.defaults' do
    it 'has default messages' do
      expect(described_class.defaults).to eq(['Chocolate Rain', 'Much Delicious. Wow.'])
    end
  end
end
