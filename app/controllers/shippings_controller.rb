class ShippingsController < ApplicationController
  DEFAULT_VALUE = 50.0
  respond_to :js

  def show
    zip_code = params[:id]
    freight = FreightCalculator.freight_for_zip zip_code, DEFAULT_VALUE
    days_to_deliver = freight[:delivery_time]
  end


end