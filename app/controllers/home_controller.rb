# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  before_filter :redirect_logged_user, :save_tracking_params, :only => :index

  def index
  end

private
  def redirect_logged_user
    redirect_to member_invite_path if user_signed_in?
  end
  
  def save_tracking_params
    session[:tracking_params] = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
  end
end
