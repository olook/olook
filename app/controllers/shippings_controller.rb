# -*- encoding : utf-8 -*-
class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :json, :js
  include FreightTracker

  def show
    @warranty_deliver = true if params[:warranty_deliver]
    @zip_code = params[:id]
    freights = shipping_freights
    return render :status => :not_found if freights.empty?
    track_zip_code_fetch_event
    prepare_freights(freights)
    @days_to_deliver = freights.fetch(:default_shipping)[:delivery_time]
    @force_show_div = true if params[:freight_service_ids]
    @freight_price = freights.fetch(:default_shipping)[:price]
    @first_free_freight_price = freights.fetch(:default_shipping)[:cost_for_free]  if freights.fetch(:default_shipping)[:cost_for_free]
  end

  private

  def shipping_freights
    FreightCalculator.freight_for_zip(
      @zip_code,
      @cart_service.subtotal > 0 ? @cart_service.subtotal : DEFAULT_VALUE,
      params[:freight_service_ids],
      true
    )
  end

end
