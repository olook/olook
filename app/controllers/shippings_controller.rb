# -*- encoding : utf-8 -*-
class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :json, :js
  include FreightTracker

  def show
    @warranty_deliver = true if params[:warranty_deliver]
    zip_code = params[:id]

    zip_code = params[:id]
    freights =  FreightCalculator.freight_for_zip(
      zip_code,
      @cart_service.subtotal > 0 ? @cart_service.subtotal : DEFAULT_VALUE,
      params[:freight_service_ids],
      true
    ).sort{|x,y| y[:delivery_time] <=> x[:delivery_time]}
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
    if @days_to_deliver <= 4
      @days_to_deliver = 2
    end
    @freight_price = freights.first[:price]
    @first_free_freight_price = freights.first[:cost_for_free]  if freights.first[:cost_for_free]
  end

end
