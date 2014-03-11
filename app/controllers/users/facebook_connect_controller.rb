class Users::FacebookConnectController < ApplicationController
  include Devise::Controllers::InternalHelpers
  def create
    @facebook_connect = FacebookConnectService.new(params[:authResponse])
    if @facebook_connect.connect!
      sign_in(@facebook_connect.user)
      render json: { redirectTo: request.referer }
    else
      render json: { error: 'Failed to connect' }, status: :unprocessable_entity
    end
  end
end
