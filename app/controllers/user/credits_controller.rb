# -*- encoding : utf-8 -*-
class User::CreditsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_order

  def index
    @member = current_user
    @invites = @member.invites.page(params[:page]).per_page(10)
  end

  def resubmit_invite
    current_user.invite_for(params[:email_address])
    redirect_to(user_credits_path, :notice => "Convite enviado com sucesso!")
  end

  private

  def load_user
    @user = current_user
  end
end
