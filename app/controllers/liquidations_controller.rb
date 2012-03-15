# -*- encoding : utf-8 -*-
class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  before_filter :verify_if_active, :only => [:show]
  before_filter :load_liquidation_products

  def show
    @teaser_banner = LiquidationService.active.teaser_banner_url if !LiquidationService.active.nil?
    respond_with @liquidation_products
  end

  def update
    respond_with @liquidation_products
  end

  private

  def load_liquidation_products
    @liquidation = Liquidation.find(params[:id])
    @liquidation_products = LiquidationSearchService.new(params).search_products
  end

  def verify_if_active
    if LiquidationService.active.try(:id) != params[:id].to_i
      flash[:notice] = "A liquidação não está ativa"
      redirect_to member_showroom_path
    end
  end
end
