# -*- encoding : utf-8 -*-
class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  before_filter :verify_if_active, :only => [:show]

  def show
    @liquidation = Liquidation.find(params[:id])

    liquidation_products = LiquidationProduct.arel_table

    @liquidation_products = LiquidationProduct.joins(:product)
                                              .where(liquidation_products[:liquidation_id].eq(@liquidation.id))
                                              .order('category asc')
                                              .paginate(:page => params[:page], :per_page => 12).order('category_id asc')
                                              .group("product_id")



    respond_with @liquidation_products
  end

  def update
    @liquidation = Liquidation.find(params[:id])

    subcategories = params[:subcategories] if params[:subcategories]
    shoe_sizes = params[:shoe_sizes] if params[:shoe_sizes]
    heels = params[:heels] if params[:heels]

    liquidation_products = LiquidationProduct.arel_table

    @liquidation_products = LiquidationProduct.joins(:product)
                                              .where(liquidation_products[:liquidation_id].eq(@liquidation.id)
                                              .and(liquidation_products[:subcategory_name].in(params[:subcategories])
                                              .or(liquidation_products[:shoe_size].in(params[:shoe_sizes])
                                              .or(liquidation_products[:heel].in(params[:heels]))))).order('category asc')
                                              .group("product_id")
                                              .paginate(:page => params[:page], :per_page => 12)



    respond_with @liquidation_products
  end

  private

  def verify_if_active
    if LiquidationService.active.try(:id) != params[:id].to_i
      flash[:notice] = "A liquidação não está ativa"
      redirect_to member_showroom_path
    end
  end
end
