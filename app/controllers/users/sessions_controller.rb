# -*- encoding : utf-8 -*-
class Users::SessionsController < Devise::SessionsController
  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    assign_gift if session[:gift_products]
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  protected
  
  def assign_gift
    GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id)
    GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id)
  end

  def create_sign_in_event
    current_user.add_event(EventType::SIGNIN)
  end

  def create_sign_out_event
    current_user.add_event(EventType::SIGNOUT)
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    if session[:gift_products]
      add_products_to_gift_cart_cart_path(:products => session[:gift_products])
    else
       if current_user.half_user
         half_user_redirect_logic
       else
         member_showroom_path
       end
    end
  end

  def half_user_redirect_logic
    if current_user.resgistered_via? :gift
      gift_root_path
    else
      lookbooks_path
    end
  end
end

