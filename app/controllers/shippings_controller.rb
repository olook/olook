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
    if freights.count > 1
        @has_two_shipping_services = true
        @shipping_service = OpenStruct.new freights.first
        @shipping_service_fast = OpenStruct.new freights.last
    else
        @shipping_service = OpenStruct.new freights.first
    end
    @days_to_deliver = freights.first[:delivery_time]
    @freight_price = freights.first[:price]
    @first_free_freight_price = freights.first[:cost_for_free]  if freights.first[:cost_for_free]
  end

end
