# -*- encoding : utf-8 -*-
module Api
  module V1
    class FreightsController < ActionController::Base

      rescue_from ArgumentError do |ex|
        render(json: ex.message, status: :unprocessable_entity) 
      end

      def show

        transport_shippings = FreightService::TransportShippingManager.new(
          params[:zip_code],
          params[:amount_value], 
          Shipping.with_zip(get_zip_code))

        render json: transport_shippings.to_json, status: :ok

      end

      private
        def get_zip_code
          if !params[:zip_code].present? || !params[:amount_value].present?          
            raise(ArgumentError, "Missing params")
          else
            zip_code = ZipCode::SanitizeService.clean(params[:zip_code])

            if ZipCode::ValidService.apply?(zip_code)
              zip_code
            else
              raise(ArgumentError, "wrong zipcode")
            end
          end
        end
    end
  end
end
