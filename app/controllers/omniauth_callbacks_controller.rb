# -*- encoding : utf-8 -*-
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if current_user
      if already_exist_a_facebook_account(env["omniauth.auth"])
        message = "Esta conta do Facebook já está em uso"
      else
        current_user.set_uid_and_facebook_token(env["omniauth.auth"])
        message = "Facebook Connect adicionado com sucesso"
      end
      redirect_to(member_showroom_path, :notice => message)
    else
      user = User.find_for_facebook_oauth(env["omniauth.auth"])
      if user
        user.set_uid_and_facebook_token(env["omniauth.auth"])
        sign_in user
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        redirect_to member_showroom_path
      else
        session["devise.facebook_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def already_exist_a_facebook_account(omniauth)
    id = omniauth["extra"]["user_hash"]["id"]
    User.find_by_uid(id)
  end

  def set_uid_and_facebook_token(current_user, omniauth)
    id = omniauth["extra"]["user_hash"]["id"]
    token = omniauth["credentials"]["token"]
    current_user.update_attributes(:uid => id, :facebook_token => token)
  end
end
