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

  def after_sign_in_path_for(resource_or_scope)

    # GiftOccasion.find(@controller.session[:occasion_id]).update_attributes(:user_id => @user.id) if @controller.session[:occasion_id]
    # GiftRecipient.find(@controller.session[:recipient_id]).update_attributes(:user_id => @user.id) if @controller.session[:recipient_id]

    # if session[:gift_products]
    #   CartBuilder.gift(self)
    # elsif session[:offline_variant]
    #   CartBuilder.offline(self)
    # els
    if current_user.half_user && current_user.male?
      gift_root_path
    else
      member_showroom_path
    end
  end
end

