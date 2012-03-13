# -*- encoding : utf-8 -*-
class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  before_filter :verify_if_active, :only => [:show]

  def show
    @liquidation = Liquidation.find(params[:id])
    @liquidation_products = LiquidationProduct.joins(:product).
                                               where("liquidation_id = ?", @liquidation.id).
                                               paginate(:page => params[:page], :per_page => 15).order('category_id asc').
                                               group("product_id")
    respond_with @liquidation_products
  end

  def update
    @liquidation = Liquidation.find(params[:id])

    subcategories = params[:subcategories] if params[:subcategories]
    shoe_sizes = params[:shoe_sizes] if params[:shoe_sizes]
    heels = params[:heels] if params[:heels]


    @liquidation_products = LiquidationProduct.joins(:product).where("liquidation_id = ? AND
                                                                      (subcategory_name IN (?) OR
                                                                      shoe_size IN (?) OR
                                                                      heel IN (?))", params[:id], subcategories, shoe_sizes, heels).
                                                                      order('category_id asc').
                                                                      group("product_id").
                                                                      paginate(:page => params[:page], :per_page => 12)
    respond_with @liquidation_products
  end

  private

  def verify_if_active
    if LiquidationService.active.try(:id) != params[:id]
      flash[:notice] = "A liquidação não está ativa"
      redirect_to member_showroom_path
    end
  end
end
