# -*- encoding : utf-8 -*-
class RegistrationsController < Devise::RegistrationsController

  before_filter :check_survey_response, :only => [:new, :create]

  def new
    @redirect_uri = new_user_registration_path 
    build_resource
    resource.is_invited = true if session[:invite]
  end

  def create
    build_resource
    resource.is_invited = true if session[:invite]

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  private

  def check_survey_response
    redirect_to survey_index_path if session[:profile_points].nil?
  end

  def after_sign_up_path_for(resource)
    SurveyAnswer.create(:answers => session[:questions], :user => resource)
    ProfileBuilder.new(resource).create_user_points(session[:profile_points])
    resource.accept_invitation_with_token(session[:invite][:invite_token]) if session[:invite]
    clean_sessions
    super resource
  end

  def clean_sessions
    session["devise.facebook_data"] = nil
    session[:profile_points] = nil
    session[:questions] = nil
    session[:invite] = nil
  end
end
