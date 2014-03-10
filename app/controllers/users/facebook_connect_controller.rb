class Users::FacebookConnectController < ApplicationController
  def create
    render json: { redirectTo: request.referer }
  end
end
