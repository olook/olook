# -*- encoding : utf-8 -*-
module Api
  module V1
    class SessionsController < ApiBasicController
      prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
      prepend_before_filter :allow_params_authentication!, :only => :create
      include Devise::Controllers::InternalHelpers
      respond_to :json

      def create
        user = User.find_by_email(params[:email])
        if user && user.valid_password?(params[:password])
          sign_in('user', user)
          render json: user.api_json
        else
          render json: { error: I18n.t("api.session_controller.create.fail")}, status: :unprocessable_entity
        end
      end

      def show
        render json: current_user.try( :api_json )
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
