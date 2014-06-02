class Users::FacebookConnectController < ApplicationController
  include Devise::Controllers::InternalHelpers
  skip_before_filter :verify_authenticity_token

  def create


    Rails.logger.error("[FACEBOOK] loging in through facebook. Parameters:#{params}")

    @facebook_connect = FacebookConnectService.new(params[:authResponse])
    new_user = new_user?
    if @facebook_connect.connect!
      @user = @facebook_connect.user
      sign_in(@facebook_connect.user)
      assign_cart_to_user(current_cart)
      render json: { redirectTo: request.referer, accessToken: @user.facebook_token, newUser: new_user }
    else
      render json: { error: 'Failed to connect' }, status: :unprocessable_entity
    end
  end

  private

  def new_user?
    user = User.find_by_email(@facebook_connect.email)
    !user
  end
end
