# -*- encoding : utf-8 -*-
class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :json, :js
  include FreightTracker

  def show
    @warranty_deliver = true if params[:warranty_deliver]
    zip_code = params[:id]

    freight =  FreightCalculator.freight_for_zip(
      zip_code,
      @cart_service.subtotal > 0 ? @cart_service.subtotal : DEFAULT_VALUE,
      params[:freight_service_ids],
      true
    )

    if freight.empty?
      render :status => :not_found
    else
      track_zip_code_fetch_event

      @days_to_deliver = freight[:delivery_time]
      if @days_to_deliver <= 4
        @days_to_deliver = 2
      end
      @freight_price = freight[:price]
      @first_free_freight_price = freight[:first_free_freight_price]  if freight[:first_free_freight_price]
      # render :show , :format => :json
    end
  end

end
