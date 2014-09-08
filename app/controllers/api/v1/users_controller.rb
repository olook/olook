# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < ApiBasicController
      respond_to :json

      include Devise::Controllers::Rememberable

      def create
        user = User.new(params[:user])
        if user.save
          sign_in user
          render json: user.api_json, status: :ok
        else
          render json: user.errors.to_json, status: :unprocessable_entity
        end
      end
    end
  end
end
