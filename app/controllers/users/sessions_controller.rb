# -*- encoding : utf-8 -*-
class Users::SessionsController < Devise::SessionsController

  FROM_WISHLIST = "1"

  layout :layout_by_resource

  after_filter :create_sign_in_event, :only => :create
  before_filter :create_sign_out_event, :only => :destroy
  after_filter :store_location


  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    referer_url = request.referer
    unless (request.url =~ /conta\/sign_in/)
      session[:previous_url] = referer_url
    end
  end

  def new
    resource = build_resource({})

    if params[:id] == FROM_WISHLIST
      flash[:notice] = "Entre para poder adicionar um item a sua lista de favoritos."
    end


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
    path = session[:previous_url] || root_path

    @cart.update_attributes(:user_id => resource.id) if @cart

    if @cart && @cart.items_total > 0
      new_checkout_url(protocol: ( Rails.env.development? ? 'http' : 'https' ))
    else
      path
    end
  end

  def layout_by_resource
    return "checkout" if params[:checkout_login] == "true"
    return "lite_application"
  end

end

