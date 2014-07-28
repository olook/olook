# -*- encoding : utf-8 -*-
module Api
  module V1
    class SessionsController < ApiBasicController
      include Devise::Controllers::InternalHelpers
      respond_to :json

      def create
        resource = warden.authenticate!(:scope => "user")
        sign_in('user', resource)
        respond_with resource
      end

      def destroy
        sign_out("user")

        # We actually need to hardcode this as Rails default responder doesn't
        # support returning empty response on GET request
        respond_to do |format|
          format.any(*navigational_formats) { redirect_to redirect_path }
          format.all do
            method = "to_#{request_format}"
            text = {}.respond_to?(method) ? {}.send(method) : ""
            render :text => text, :status => :ok
          end
        end
      end
    end
  end
end
