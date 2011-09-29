class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :check_survey_response, :only => [:facebook]

  def facebook
    survey_answer = SurveyAnswer.new(:answers => session[:questions])
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], survey_answer)
    if @user.persisted?
      @user.counts_and_write_points(session[:profile_points])
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def check_survey_response
    redirect_to survey_index_path if session[:profile_points].nil?
  end
end
