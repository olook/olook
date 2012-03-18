# -*- encoding : utf-8 -*-
class Admin::PromotionsController < Admin::BaseController
  
  #load_and_authorize_resource

  respond_to :html

  def index
    @promotions = Promotion.all
    respond_with @promotions
  end

  def show
    @promotion = Promotion.find(params[:id])
    respond_with @promotion
  end

  def new
    @promotion = Promotion.new
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def create
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
      flash[:notice] = 'Promotion was successfully created.'
    end
    respond_with :admin, @promotion
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
      flash[:notice] = 'Promotion was successfully updated.'
    end
    respond_with :admin, @promotion
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy
    flash[:notice] = "Successfully destroy promotion"
    respond_with :admin, @promotion
  end
end
