class Users::FacebookConnectController < ApplicationController
  def create
    @facebook_connect = FacebookConnectService.new(params[:facebookData], params[:authResponse])
    render json: { redirectTo: request.referer }
  end
end
