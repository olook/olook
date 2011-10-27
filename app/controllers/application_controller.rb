# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :authenticate
  protect_from_forgery

  rescue_from Contacts::AuthenticationError, :with => :contact_authentication_failed
  rescue_from GData::Client::CaptchaError, :with => :contact_authentication_failed

  protected

  def authenticate
    if Rails.env == "production"
      authenticate_or_request_with_http_basic do |username, password|
        username == "olook" && password == "olook123abc"
      end
    end
  end

  def contact_authentication_failed
    flash[:notice] = "Falha de autenticação na importação de contatos"
    redirect_to :back
  end
end
