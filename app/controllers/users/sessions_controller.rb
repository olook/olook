# -*- encoding : utf-8 -*-
class Users::SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  protected
  def create_sign_in_event
    current_user.add_event(EventType::SIGNIN)
  end

  def create_sign_out_event
    current_user.add_event(EventType::SIGNOUT) if current_user
  end

  def after_sign_in_path_for(resource)

    @cart.update_attributes(:user_id => resource.id)

    if @cart.has_gift_items?
      GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id) if session[:occasion_id]
      GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id) if session[:recipient_id]
    end
    
    if @cart.items_total > 0
      if resource.current_credit > 0
        cart_path
      else
        cart_checkout_addresses_path
      end
    elsif resource.half_user && resource.male?
      gift_root_path
    else
      member_showroom_path
    end
  end
end

