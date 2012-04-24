# -*- encoding : utf-8 -*-
class SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy
    
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if session[:gift_products]
      GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id)
      GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id)
    end
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  protected

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
    if resource_or_scope.is_a?(Admin)
      admin_path
    elsif session[:gift_products]
      add_products_to_gift_cart_cart_path(:products => session[:gift_products])
    else
      if current_user.half_user
        gift_root_path
      else
        member_showroom_path
      end
    end
  end
end

