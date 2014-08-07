# -*- encoding : utf-8 -*-
module Api
  module V1
    class FreightsController < ApiBasicController
      skip_before_filter :restrict_access

      rescue_from ArgumentError do |ex|
        render(json: ex.message, status: :unprocessable_entity)
      end

      def index
        zip_code = get_zip_code
        transport_shippings = FreightService::TransportShippingManager.new(
          zip_code,
          params[:amount_value],
          Shipping.with_zip(zip_code)
        )
        render json: transport_shippings.api_hash, status: :ok
      end

      private

      def get_zip_code
        zip_code = ZipCode::SanitizeService.clean(params[:zip_code])

        if zip_code.blank? || params[:amount_value].blank?
          raise(ArgumentError, "Missing params")
        elsif !ZipCode::ValidService.apply?(zip_code)
          raise(ArgumentError, "wrong zipcode")
        else
          zip_code
        end
      end
    end
  end
end
