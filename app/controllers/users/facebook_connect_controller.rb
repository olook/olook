class Users::FacebookConnectController < ApplicationController
  include Devise::Controllers::InternalHelpers
  skip_before_filter :verify_authenticity_token

  def create
    @facebook_connect = FacebookConnectService.new(params[:authResponse])
    if @facebook_connect.connect!
      @user = @facebook_connect.user
      sign_in(@facebook_connect.user)
      assign_cart_to_user(current_cart)
      render json: { redirectTo: request.referer }
    else
      render json: { error: 'Failed to connect' }, status: :unprocessable_entity
    end
  end
end
