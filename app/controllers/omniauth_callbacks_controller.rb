# -*- encoding : utf-8 -*-
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if current_user
      current_user.set_facebook_data(env["omniauth.auth"], session)
      if session[:facebook_scopes]
        if session[:facebook_scopes].include? "friends_birthday"
          redirect_path = gift_root_path
        else  
          redirect_path = friends_home_path
        end
        session[:facebook_scopes] = nil
      else
        redirect_path = member_showroom_path
      end
      redirect_to(redirect_path, :notice => I18n.t("facebook.connect_success"))
    else
      user = User.find_for_facebook_oauth(env["omniauth.auth"])
      if user
        user.set_facebook_data(env["omniauth.auth"], session)
        sign_in user
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        redirect_to member_showroom_path
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def passthru
    session[:facebook_scopes] = session[:should_request_new_facebook_token] ? "publish_stream" : ""
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def failure
    redirect_to(member_showroom_path, :alert => I18n.t("facebook.connect_failure"))
  end

  private

  def already_exist_a_facebook_account(omniauth)
    id = omniauth["extra"]["user_hash"]["id"]
    User.find_by_uid(id)
  end
end
