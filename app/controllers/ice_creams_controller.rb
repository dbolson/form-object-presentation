class IceCreamsController < ApplicationController
  respond_to :html

  def index
    @ice_creams = IceCream.all

    respond_with @ice_creams
  end

  def show
    @ice_cream = IceCream.find(params[:id])

    respond_with @ice_cream
  end

  def new
    @ice_cream = IceCream.new

    respond_with @ice_cream
  end

  def create
    @ice_cream = IceCream.new(valid_params)

    if @ice_cream.save
      Meme.create_defaults(@ice_cream)
      redirect_to edit_ice_cream_path(@ice_cream), notice: 'Ice cream was successfully created.'
    else
      render :new
    end
  end

  def edit
    @ice_cream = IceCream.find(params[:id])
    (3 - @ice_cream.memes.size).times { @ice_cream.memes.build }

    respond_with @ice_cream
  end

  def update
    @ice_cream = IceCream.find(params[:id])

    if @ice_cream.update_attributes(valid_params)
      redirect_to edit_ice_cream_path(@ice_cream), notice: 'Ice cream was successfully updated.'
    else
      (3 - @ice_cream.memes.size).times { @ice_cream.memes.build }
      render :edit
    end
  end

  def destroy
    @ice_cream = IceCream.find(params[:id])
    @ice_cream.destroy

    respond_with @ice_cream, location: ice_creams_path
  end

  private

  def valid_params
    params
      .require(:ice_cream)
      .permit(:flavor_id,
              :serving_size_id,
              :scoops,
              topping_ids: [],
              memes_attributes: [:id, :name, :rating, :_destroy])
  end
end
