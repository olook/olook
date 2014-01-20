# -*- encoding : utf-8 -*-
class Users::SessionsController < Devise::SessionsController
  layout :layout_by_resource

  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy

  def new
    resource = build_resource({})
    unless flash[:alert].nil?
      flash[:alert] = nil
      resource.errors.add(" ", I18n.t('devise.failure.invalid'))
    end

    if params[:checkout_login] == "true" # request.referer =~ /pagamento\/login/ && resource.errors.any?
      # respond_with resource, checkout_login_index_path
      respond_with(resource) { |format| format.html { render "/checkout/login/index" } }
    else
      respond_with resource
    end
  end

  protected

  def create_sign_in_event
    current_user.add_event(EventType::SIGNIN)
  end

  def create_sign_out_event
    current_user.add_event(EventType::SIGNOUT) if current_user
  end

  def after_sign_in_path_for(resource)
    @cart.update_attributes(:user_id => resource.id) if @cart

    if @cart && @cart.has_gift_items?
      GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id) if session[:occasion_id]
      GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id) if session[:recipient_id]
    end

    if @cart && @cart.items_total > 0
      new_checkout_path
    elsif resource.half_user && resource.male?
      gift_root_path
    else
      member_showroom_path
    end
  end

  def layout_by_resource
    return "checkout" if params[:checkout_login] == "true"
    return "lite_application"
  end

end

