# -*- encoding : utf-8 -*-
class RegistrationsController < Devise::RegistrationsController

  before_filter :check_survey_response, :only => [:new, :create]

  def new
    if data = user_data_from_session
      build_resource(:email => data["email"], :first_name => data["first_name"], :last_name => data["last_name"])
    else
      build_resource
    end
    resource.is_invited = true if session[:invite]
  end

  def create
    build_resource
    if data = user_data_from_session
      resource.uid = data["id"]
      resource.facebook_token = session["devise.facebook_data"]["credentials"]["token"]
    end

    resource.is_invited = true if session[:invite]

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        after_sign_up_path_for(resource)
        redirect_to welcome_path
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

  def user_data_from_session
    session["devise.facebook_data"]["extra"]["user_hash"] if session["devise.facebook_data"]
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
  end

  def clean_sessions
    session["devise.facebook_data"] = nil
    session[:profile_points] = nil
    session[:questions] = nil
    session[:invite] = nil
  end
end
