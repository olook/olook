# -*- encoding : utf-8 -*-
class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  before_filter :verify_if_active, :only => [:show]

  def show
    @liquidation = Liquidation.find(params[:id])
    @liquidation_products = LiquidationSearchService.new(params).search_products
    respond_with @liquidation_products
  end

  def update
    @liquidation = Liquidation.find(params[:id])
    @liquidation_products = LiquidationSearchService.new(params).search_products
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
