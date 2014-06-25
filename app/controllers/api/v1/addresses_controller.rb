module Api
  module V1
    class AddressesController < ApiBasicController
      respond_to :json

      before_filter :authenticate_user!

      def index
        render json: current_user.addresses.to_json
      end

      def destroy
        selected_address(params[:id]).destroy
        head :ok, content_type: :json
      end

      def create
        params[:address][:country] = 'BRA' if params[:address]    
        address = current_user.addresses.create(params[:address])

        respond_with address
      end

      def update
        address = selected_address(params[:id])
        if address.update_attributes(params[:address])
          render json: address.to_json, status: :ok
        else  
          render json: address.errors.to_json, status: :unprocessable_entity
        end
      end  

      def show
        address = selected_address(params[:id])
        render json: address.to_json, status: :ok
      rescue ActiveRecord::RecordNotFound
        head :not_found, content_type: :json
      end

      def address_url(address)
        api_v1_address_path(address)
      end

      private

      def selected_address id
        current_user.addresses.active.find(params[:id])
      end

    end
  end
end
