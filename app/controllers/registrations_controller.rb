class RegistrationsController < Devise::RegistrationsController
 
  before_filter :check_survey_response, :only => [:new, :create]
  
  private
  
  def check_survey_response
  	redirect_to survey_index_path if session[:profile_points].nil?
  end
  
  def after_sign_up_path_for(new_member)
    save_survey_answers(new_member)
    new_member.accept_invitation_with_token(session[:invite][:invitation_token]) if session[:invite]
  end
  
  def save_survey_answers(new_member)
  	SurveyAnswer.create(:answers => session[:questions], :user => new_member)
    new_member.counts_and_write_points(session[:profile_points])
  end
end
