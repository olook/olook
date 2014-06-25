# -*- encoding : utf-8 -*-
module Api
  module V1
    class FreightsController < ActionController::Base
      def show
        return render json: "Missing params", status: :unprocessable_entity if !params[:zip_code].present? || !params[:amount_value].present?
        zip_code = ZipCode::SanitizeService.clean(params[:zip_code])
        return render json: "wrong zipcode", status: :unprocessable_entity if !ZipCode::ValidService.apply?(zip_code)
        transport_shippings = Freight::TransportShippingManager.new(params[:zip_code],params[:amount_value], Shipping.with_zip(zip_code))
        render json: {default_shipping: transport_shippings.default, fast_shipping: transport_shippings.fast}, status: :ok
      end
    end
  end
end
