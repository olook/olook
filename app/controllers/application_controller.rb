# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :authenticate

  protect_from_forgery

  protected

  def authenticate
    if Rails.env == "production"
      authenticate_or_request_with_http_basic do |username, password|
        username == "olook" && password == "olook123abc"
      end
    end
  end

end
