class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if current_user
      set_uid_and_facebook_token(current_user, env["omniauth.auth"])
      redirect_to root_path
    else
      if user = User.find_for_facebook_oauth(env["omniauth.auth"])
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in user
        redirect_to welcome_path
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

  def set_uid_and_facebook_token(current_user, omniauth)
    id = omniauth["extra"]["user_hash"]["id"]
    token = omniauth["credentials"]["token"]
    current_user.update_attributes(:uid => id, :facebook_token => token)
  end

end
