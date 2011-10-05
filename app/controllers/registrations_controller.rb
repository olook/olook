class RegistrationsController < Devise::RegistrationsController

  before_filter :check_survey_response, :only => [:new, :create]

  def new
    @user_data = session['devise.facebook_data'] ? session['devise.facebook_data']['extra']['user_hash'] : {}
    super
  end

  private

  def check_survey_response
    redirect_to survey_index_path if session[:profile_points].nil?
  end

  def after_sign_up_path_for(resource)
    SurveyAnswer.create(:answers => session[:questions], :user => resource)
    resource.counts_and_write_points(session[:profile_points])
    resource.accept_invitation_with_token(session[:invite][:invite_token]) if session[:invite]
    super resource
  end
end
