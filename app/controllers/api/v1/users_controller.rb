# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < ApiBasicController

    	include Devise::Controllers::Rememberable

      def create
        user = User.create(params[:user])
        sign_in user
        respond_with user
      end

      def user_url value
      	"teste"
      end

    end
  end
end
