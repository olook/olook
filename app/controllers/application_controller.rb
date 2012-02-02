# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "site"

  rescue_from Contacts::AuthenticationError, :with => :contact_authentication_failed
  rescue_from GData::Client::CaptchaError, :with => :contact_authentication_failed
  rescue_from Koala::Facebook::APIError , :with => :facebook_token_expired

  private

  def facebook_token_expired
    flash[:should_request_new_facebook_toke] = true
    redirect_to facebook_connect_path, :notice => "Sua autenticação como o Facebook expirou. Faça o login novamente por favor"
  end

  def contact_authentication_failed
    flash[:notice] = "Falha de autenticação na importação de contatos"
    redirect_to :back
  end

  protected

  def user_for_paper_trail
    user_signed_in? ? current_user : current_admin
  end

  def load_user
    @user = current_user
  end

  def load_order
    @order = current_user.orders.find_by_id(session[:order]) if current_user
  end

  def check_early_access
    if current_user
      redirect_to member_invite_path unless current_user.has_early_access?
    end
  end

  def assign_default_country
    params[:address][:country] = 'BRA'
  end
end

