require 'spec_helper'

describe OrdersController, :integration do
  describe '#index' do
    let(:ice_cream) { create(:ice_cream) }

    before do
      get :index
    end

    it 'renders the "index" page' do
      expect(response).to render_template(:index)
    end

    it 'exposes the all the orders' do
      expect(assigns(:orders)).to eq([ice_cream])
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it 'renders the "new" view' do
      expect(response).to render_template(:new)
    end

    it 'sets the order form' do
      expect(assigns(:order)).to be_a_kind_of(NewOrderForm)
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:params) {{
        flavor_id: 1,
        serving_size_id: 1,
        scoops: 1,
        topping_ids: [1]
      }}
      let(:order) { assigns(:order) }

      before do
        post :create, order: params
      end

      it 'saves the ice cream' do
        expect(order.model).to be_persisted
      end

      it 'sets the order price' do
        expect(order.model.price).to eq(100)
      end

      it 'saves the default memes' do
        expect(order.model.memes.size).to eq(Meme.defaults.size)
      end

      it 'redirects to the edit order page' do
        expect(response).to redirect_to(edit_order_path(order))
      end
    end

    context 'with invalid parameters' do
      let(:params) {{
        flavor_id: nil,
        serving_size_id: nil,
        scoops: nil,
        topping_ids: []
      }}
      let(:order) { assigns(:order) }

      before do
        post :create, order: params
      end

      it 'renders the "new" view' do
        expect(response).to render_template(:new)
      end

      it 'assigns errors to the order' do
        expect(order.errors).to be_present
      end
    end
  end

  describe '#edit' do
    let(:ice_cream) { create(:ice_cream) }

    before do
      get :edit, id: ice_cream.id
    end

    it 'renders the "edit" view' do
      expect(response.body).to render_template(:edit)
    end

    it 'sets the order form' do
      expect(assigns(:order)).to be_a_kind_of(EditOrderForm)
    end

    context 'with less than 3 memes' do
      it 'sets the memes fields to 3' do
        get :edit, id: ice_cream.id
        expect(assigns(:order).memes.size).to eq(3)
      end
    end
  end

  describe '#update' do
    let(:meme1) { create(:meme, name: 'default 1', rating: 10) }
    let(:meme2) { create(:meme, name: 'default 2', rating: 10) }
    let(:ice_cream) { create(:ice_cream, memes: [meme1, meme2]) }

    context 'with valid parameters' do
      let(:params) {{
        flavor_id: 1,
        serving_size_id: 1,
        scoops: 1,
        topping_ids: [1],
        memes: [
          { id: meme1.id, name: meme1.name, rating: 10, _destroy: '1' },
          { id: meme2.id, name: 'edited name', rating: 9 },
          { name: 'new name', rating: 10 }
        ]
      }}
      let(:order) { assigns(:order) }

      before do
        put :update, id: ice_cream.id, order: params
      end

      it 'updates the ice cream' do
        expect(order.model).to be_persisted
      end

      it 'deletes flagged memes' do
        expect(order.model.memes).to_not include(meme1)
      end

      it 'adds new memes' do
        expect(order.model.memes.size).to eq(2)
      end

      it 'updates memes' do
        updated_meme = order.model.memes.detect { |m| m.id == meme2.id }
        expect(updated_meme.name).to eq('edited name')
        expect(updated_meme.rating).to eq(9)
      end

      it 'redirects back to the edit order page' do
        expect(response).to redirect_to(edit_order_path(order))
      end
    end

    context 'with invalid parameters' do
      let(:params) {{
        flavor_id: nil,
        serving_size_id: nil,
        scoops: nil,
        topping_ids: [nil],
        memes: [
          { name: nil, rating: nil }
        ]
      }}

      before do
        put :update, id: ice_cream.id, order: params
      end

      it 'renders the "edit" view' do
        expect(response).to render_template(:edit)
      end

      it 'sets the memes fields to 3' do
        expect(assigns(:order).memes.size).to eq(3)
      end

      it 'assigns errors to the order' do
        expect(assigns(:order).errors).to be_present
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
      expect(response).to redirect_to(orders_path)
    end
  end
end
