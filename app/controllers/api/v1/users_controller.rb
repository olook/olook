# -*- encoding : utf-8 -*-
module Api
  module V1
    class UsersController < ApiBasicController

    	include Devise::Controllers::Rememberable

      def create    
binding.pry
        name = params[:user].delete(:name)
        values = name.split(" ")

        params[:user][:first_name] = values.shift
        params[:user][:last_name] = values.join(" ")

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
