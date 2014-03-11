require 'spec_helper'

describe IceCreamsController, :integration do
  describe '#index' do
    let(:ice_cream) { create(:ice_cream) }

    before do
      get :index
    end

    it 'renders the "index" page' do
      expect(response).to render_template(:index)
    end

    it 'exposes the all the ice cream orders' do
      expect(assigns(:ice_creams)).to eq([ice_cream])
    end
  end

  describe '#new' do
    let(:ice_cream) { assigns(:ice_cream) }

    before do
      get :new
    end

    it 'renders the "new" page' do
      expect(response).to render_template(:new)
    end

    it 'exposes a new ice cream order' do
      expect(ice_cream).to be_a_kind_of(IceCream)
    end

    it 'sets up the new ice cream order with memes' do
      expect(ice_cream.memes.size).to eq(3)
    end
  end

  describe '#create' do
    describe 'with valid parameters' do
      let(:params) {{
        flavor_id: 1,
        serving_size_id: 1,
        scoops: 1,
        topping_ids: [1]
      }}
      let(:ice_cream) { assigns(:ice_cream) }

      before do
        post :create, ice_cream: params
      end

      it 'saves the ice cream order' do
        expect(ice_cream).to be_persisted
      end

      it 'saves the ice cream order with memes' do
        expect(ice_cream.memes.size).to eq(Meme.defaults.size)
      end

      it 'redirects to the edit ice cream order page' do
        expect(response).to redirect_to(edit_ice_cream_path(ice_cream))
      end
    end

    describe 'with invalid parameters' do
      let(:params) {{
        flavor_id: -1,
        serving_size_id: -1,
        scoops: -1,
        topping_ids: [-1]
      }}
      let(:ice_cream) { assigns(:ice_cream) }

      before do
        post :create, ice_cream: params
      end

      it 'renders the "new" page' do
        expect(response).to render_template(:new)
      end

      it 'exposes a new ice cream order with errors' do
        expect(ice_cream.errors).to be_present
      end
    end
  end

  describe '#edit' do
    let(:ice_cream) { create(:ice_cream) }

    before do
      get :edit, id: ice_cream.id
    end

    it 'renders the "edit" page' do
      expect(response).to render_template(:edit)
    end

    it 'exposes the ice cream order' do
      expect(assigns(:ice_cream)).to eq(ice_cream)
    end

    it 'exposes the ice cream order with up to 3 memes' do
      expect(assigns(:ice_cream).memes.size).to eq(3)
    end
  end

  describe '#update' do
    let(:ice_cream) { create(:ice_cream, scoops: 1) }

    describe 'with valid parameters' do
      let(:params) {{
        flavor_id: 1,
        serving_size_id: 1,
        scoops: 2,
        topping_ids: [1]
      }}

      before do
        put :update, id: ice_cream.id, ice_cream: params
      end

      it 'updates the ice cream order' do
        expect(assigns(:ice_cream).scoops).to eq(2)
      end

      it 'redirects back to the edit ice cream order page' do
        expect(response).to redirect_to(edit_ice_cream_path(ice_cream))
      end
    end

    describe 'with invalid parameters' do
      let(:params) {{
        flavor_id: -1,
        serving_size_id: -1,
        scoops: -1,
        topping_ids: [-1],
        memes_attributes: {
          '0' => { name: 'new comment', rating: 10 },
          '1' => { name: 'new comment', rating: 10 }
        }
      }}

      before do
        put :update, id: ice_cream.id, ice_cream: params
      end

      it 'renders the "edit" page' do
        expect(response).to render_template(:edit)
      end

      it 'exposes a new ice cream order with errors' do
        expect(assigns(:ice_cream).errors).to be_present
      end

      it 'exposes the ice cream order with up to 3 memes' do
        expect(assigns(:ice_cream).memes.size).to eq(3)
      end
    end
  end

  describe '#destroy' do
    let(:ice_cream) { create(:ice_cream) }

    it 'deletes the ice cream order' do
      delete :destroy, id: ice_cream.id
      expect(IceCream.exists?(ice_cream.id)).to be_falsy
    end

    it 'redirects to the index page' do
      delete :destroy, id: ice_cream.id
      expect(response).to redirect_to(ice_creams_path)
    end
  end
end
