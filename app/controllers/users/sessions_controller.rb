# -*- encoding : utf-8 -*-
class Users::SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  protected
  def create_sign_in_event
    current_user.add_event(EventType::SIGNIN)
  end

  def create_sign_out_event
    current_user.add_event(EventType::SIGNOUT)
  end

  def after_sign_in_path_for(resource_or_scope)
    if session[:gift_products]
      CartBuilder.gift(self, resource_or_scope)
    elsif session[:offline_variant]
      CartBuilder.offline(self, resource_or_scope)
    elsif current_user.half_user && current_user.male?
      gift_root_path
    else
      member_showroom_path
    end
  end
end

