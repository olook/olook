class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    survey_answer = SurveyAnswer.new(:answers => session[:questions])
    @user, new_user = User.find_for_facebook_oauth(env["omniauth.auth"], survey_answer, session[:profile_points])

    if new_user && session[:profile_points].nil?
      redirect_to survey_index_path
    else
      if @user.persisted?
        @user.counts_and_write_points(session[:profile_points])
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in @user
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
