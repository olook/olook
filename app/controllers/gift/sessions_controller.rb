# -*- encoding : utf-8 -*-
class Gift::SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  after_filter :save_user_to_occasions, :only => :create  
  before_filter :create_sign_out_event, :only => :destroy
  
  protected
  
  def save_user_to_occasions
    GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => current_user.id)
    GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => current_user.id)
  end
  
  def create_sign_in_event
    if current_user.is_a?(User)
      current_user.add_event(EventType::SIGNIN)
    end
  end

  def create_sign_out_event
    if current_user.is_a?(User)
      current_user.add_event(EventType::SIGNOUT)
    end
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    add_products_to_gift_cart_cart_path(:products => session[:gift_products])
  end
end

