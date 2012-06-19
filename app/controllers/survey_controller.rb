# -*- encoding : utf-8 -*-
class SurveyController < ApplicationController
  respond_to :json, :only => :check_date

  before_filter :check_user_login, :except => [:create, :new, :check_date]
  before_filter :check_questions_params, :only => [:create]

  def new
    @questions = Question.from_registration_survey
    @presenter = SurveyQuestions.new(@questions)
  end

  def create
    session[:questions] = questions = params[:questions]
    session[:birthday] = {:day => params[:day], :month => params[:month], :year => params[:year]}
    profiles = ProfileBuilder.profiles_given_questions(questions)
    profile_points = ProfileBuilder.build_profiles_points(profiles)
    session[:profile_points] = profile_points
    if current_user
      current_user.points.delete_all if current_user.points
      current_user.survey_answer.delete if current_user.survey_answer
      answers = (session[:birthday].nil?) ? session[:questions] : session[:questions].merge(session[:birthday])
      SurveyAnswer.create(:answers => answers, :user => current_user)
      ProfileBuilder.new(current_user).create_user_points(session[:profile_points])
      current_user.upgrade_to_full_user!
      redirect_to root_path
    else
      redirect_to new_user_registration_path
    end
  end

  def check_date
    error_message = I18n.t 'errors.messages.invalid_date' if is_date_invalid?(params)
    respond_to do |format|
      format.json { render :json => { :message => error_message } }
    end
  end

  private

  def check_user_login
    redirect_to root_path if current_user
  end

  def check_questions_params
    redirect_to new_survey_path if (params[:questions].nil? || is_date_invalid?(params))
  end

  def is_date_invalid?(params)
    !Date.valid_date?(params[:year].to_i,params[:month].to_i,params[:day].to_i)
  end
end
