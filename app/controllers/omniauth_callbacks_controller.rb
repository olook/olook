class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    user = User.find_for_facebook_oauth(env["omniauth.auth"])
    if user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in user
      redirect_to welcome_path
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end
