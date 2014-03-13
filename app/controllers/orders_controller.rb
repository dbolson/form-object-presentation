class OrdersController < ApplicationController
  before_action :find_ice_cream, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @orders = IceCream.order('created_at DESC')

    respond_with @orders
  end

  def new
    @order = NewOrderForm.new

    respond_with @order
  end

  def create
    @order = NewOrderForm.new(valid_params)

    if @order.save
      redirect_to edit_order_path(@order), notice: 'Your order was created.'
    else
      render :new
    end
  end

  def edit
    @order = EditOrderForm.new(@ice_cream)

    respond_with @order
  end

  def update
    @order = EditOrderForm.new(@ice_cream, valid_params)

    if @order.save
      redirect_to edit_order_path(@order), notice: 'Your order was updated.'
    else
      render :edit
    end
  end

  def destroy
    @ice_cream.destroy

    respond_with @ice_cream, notice: 'Your order was deleted.', location: orders_path
  end

  private

  def find_ice_cream
    @ice_cream = IceCream.find(params[:id])
  end

  def valid_params
    params
      .require(:order)
      .permit(:flavor_id,
              :serving_size_id,
              :scoops,
              topping_ids: [],
              memes: [:id, :name, :rating, :_destroy])
  end
end
