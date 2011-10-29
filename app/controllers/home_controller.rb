# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  before_filter :redirect_logged_user, :only => :index

  def index
  end

private
  def redirect_logged_user
    redirect_to member_invite_path if user_signed_in?
  end
end
