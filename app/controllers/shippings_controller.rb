# -*- encoding : utf-8 -*-
class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :json, :js
  include FreightTracker

  def show
    @cart_calculator = CartProfit::CartCalculator.new(@cart)    
    @warranty_deliver = true if params[:warranty_deliver]
    @zip_code = params[:id]
    freights = shipping_freights(params[:prevent_policy])
    prepare_freights(freights)
    if freights.empty?
      render :status => :not_found 
    else
      track_zip_code_fetch_event
      @days_to_deliver = freights.fetch(:default_shipping)[:delivery_time]
      @freight_price = freights.fetch(:default_shipping)[:price]
      @first_free_freight_price = freights.fetch(:default_shipping)[:cost_for_free]  if freights.fetch(:default_shipping)[:cost_for_free]
    end
  end

  private

  def shipping_freights(prevent_policy)
    prevent_shipping = {}
    prevent_shipping.merge!(prevent_policy: 'true') if params[:prevent_policy] == 'true'
    FreightCalculator.freight_for_zip(
      @zip_code,
      @cart_service.subtotal > 0 ? @cart_service.subtotal : DEFAULT_VALUE,
      params[:freight_service_ids],
      prevent_shipping
    )
  end

end
