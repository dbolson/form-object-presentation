require 'spec_helper'

describe Meme do
  describe 'relationships' do
    it 'belongs to an ice cream' do
      expect(described_class.new).to respond_to(:ice_cream)
    end
  end

  describe 'validations' do
    let(:meme) { described_class.new }

    it 'requires an ice cream' do
      meme.valid?
      expect(meme.errors[:ice_cream]).to be_present
    end

    it 'requires a name' do
      meme.valid?
      expect(meme.errors[:name]).to be_present
    end

    it 'requires a unique name for an ice cream' do
      existing_same_ice_cream = create(:meme)
      existing_different_ice_cream = create(:meme)
      meme.ice_cream = existing_same_ice_cream.ice_cream
      meme.name = existing_same_ice_cream.name
      meme.valid?
      expect(meme.errors[:name]).to be_present
    end

    it 'requires rating' do
      meme.valid?
      expect(meme.errors[:rating]).to be_present
    end

    it 'cannot have too small of a rating' do
      meme.rating = 0
      meme.valid?
      expect(meme.errors[:rating]).to be_present
    end

    it 'cannot have too high of a rating' do
      meme.rating = 11
      meme.valid?
      expect(meme.errors[:rating]).to be_present
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
