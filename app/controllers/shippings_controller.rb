# -*- encoding : utf-8 -*-
class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :json, :js
  include FreightTracker

  def show
    zip_code = params[:id]

    freights =  FreightCalculator.freight_for_zip(
      zip_code,
      @cart_service.subtotal > 0 ? @cart_service.subtotal : DEFAULT_VALUE,
      params[:freight_service_ids],
      true
    )
    return render :status => :not_found if freights.empty?
      
    track_zip_code_fetch_event
    @has_two_shipping_services = freights.count > 1
    #@days_to_deliver = freight[:delivery_time]
    #@freight_price = freight[:price]
    #@first_free_freight_price = freight[:first_free_freight_price]  if freight[:first_free_freight_price]
  end

end
