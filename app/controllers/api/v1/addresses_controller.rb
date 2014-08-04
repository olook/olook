module Api
  module V1
    class AddressesController < ApiBasicController
      respond_to :json

      before_filter :authenticate_user!

      def index
        render json: addresses.to_json
      end

      def destroy
        selected_address(params[:id]).deactivate
        head :ok, content_type: :json
      rescue ActiveRecord::RecordNotFound
        head :not_found, content_type: :json
      end

      def create
        address = current_user.addresses.new(params[:address])
        response_for address
      end

      def update        
        address = selected_address(params[:id])
        params[:address].delete(:id)
        address.update_attributes(params[:address])
        response_for address
      rescue ActiveRecord::RecordNotFound
        head :not_found, content_type: :json
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

      def addresses
        current_user.addresses.active
      end

      def selected_address id
        addresses.find(params[:id])
      end

      def response_for address
        if address.save
          render json: address.to_json, status: :ok
        else
          render json: address.errors.to_json, status: :unprocessable_entity
        end
      end

    end
  end
end
