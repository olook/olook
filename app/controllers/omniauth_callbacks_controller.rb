class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if current_user
      id = env["omniauth.auth"]["extra"]["user_hash"]["id"]
      token = env["omniauth.auth"]["credentials"]["token"]
      current_user.update_attributes(:uid => id, :facebook_token => token)
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

end
