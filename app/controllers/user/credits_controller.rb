# -*- encoding : utf-8 -*-
class User::CreditsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_order

  def index
    @invites = @user.invites.page(params[:page]).per_page(10)
  end
end

