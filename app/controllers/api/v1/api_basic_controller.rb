# -*- encoding : utf-8 -*-
module Api
  module V1
    class ApiBasicController < ActionController::Base
      protect_from_forgery

      before_filter :restrict_access, if: -> {Rails.env.production?}
      respond_to :json

      protected
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          api_key = ApiKey.find_by_access_token(token)
          params[:api_client_name] = api_key.name if api_key
          api_key
        end
      end
    
    end
  end

end
