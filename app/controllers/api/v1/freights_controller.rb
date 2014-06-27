# -*- encoding : utf-8 -*-
module Api
  module V1
    class FreightsController < ApiBasicController
      skip_before_filter :restrict_access

      def show
        transport_shippings = FreightService::TransportShippingManager.new(
          params[:zip_code],
          params[:amount_value], 
          Shipping.with_zip(get_zip_code))
        render json: transport_shippings.to_json, status: :ok
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
