# -*- encoding : utf-8 -*-
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if current_user
      current_user.set_facebook_data(env["omniauth.auth"])
      session[:facebook_scopes] = nil if session[:facebook_scopes]
      path_key = session[:facebook_redirect_paths] || :showroom
      redirect_path = facebook_redirect_paths[path_key.to_sym]
      redirect_to(redirect_path, :notice => I18n.t("facebook.connect_success"))
    else
      user = User.find_for_facebook_oauth(env["omniauth.auth"])
      if user
        user.set_facebook_data(env["omniauth.auth"])
        sign_in user
        set_user_profile(user) if session[:qr]
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        redirect user
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        if session[:qr]
          redirect_to join_path
        elsif @cart && @cart.items.any?
          redirect_to new_half_user_session_path(:checkout_registration => "true")
        else
          redirect_to new_user_registration_url
        end
      end
    end
  end

  def passthru
    session[:facebook_scopes] = session[:should_request_new_facebook_token] ? "publish_stream" : ""
    render :template => "/errors/404", :layout => 'error', :status => 404, :handlers => [:erb]
  end

  def failure
    redirect_to(member_showroom_path, :alert => I18n.t("facebook.connect_failure"))
  end

  def setup
    request.env['omniauth.strategy'].options[:scope] = User::ALL_FACEBOOK_PERMISSIONS # session[:facebook_scopes]
    render :text => "Setup complete.", :status => 404
  end

  private

    #
    # Clearly this isn't the best place to put this code, but the problem is that putting this
    # logic in ApplicationController#current_referer doesn't work because the user is not
    # loaded yet on that point
    #
    def redirect user
      if @cart && @cart.items.any?
        redirect_to new_checkout_url(protocol: 'https')
      elsif session[:qr]
        @qr.next_step
      elsif !user.half_user?
        redirect_to member_showroom_path
      else
        redirect_to gift_root_path
      end
    end

    def facebook_redirect_paths
      {:friends => friends_home_path, :gift => gift_root_path, :showroom => member_showroom_path, :checkout => new_checkout_url(protocol: 'https'), :quiz => profile_path}
    end

    def already_exist_a_facebook_account(omniauth)
      id = omniauth["extra"]["user_hash"]["id"]
      User.find_by_uid(id)
    end

    def set_user_profile(user)
      if load_quiz_responder
        @qr = QuizResponder.find(@quiz_responder[:uuid])
        @qr.user = user
        @qr.validate!
        @qr
      else
         QuizResponder.new(user)
      end
    end
    def load_quiz_responder
      @quiz_responder = session[:qr]
    end
end
