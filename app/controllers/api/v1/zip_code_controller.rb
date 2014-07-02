module Api
  module V1
    class ZipCodeController < ApiBasicController
      respond_to :json

      before_filter :authenticate_user!

      def show
        cep = Cep.find_by_cep(params[:id].gsub("-",""))
        if cep
          render json: cep.adapt_cep_to_address_hash.to_json, status: :ok
        else
          head :not_found, content_type: :json
        end
      end

    end
  end
end