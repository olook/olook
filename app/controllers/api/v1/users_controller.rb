# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < ApiBasicController
      respond_to :json

    	include Devise::Controllers::Rememberable

      def create
        user = User.create(params[:user])
        sign_in user
        response_for user
      end

      def response_for user
        if user.save
          render json: user.to_json, status: :ok
        else
          render json: user.errors.to_json, status: :unprocessable_entity
        end
      end

    end
  end
end
