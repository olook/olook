# -*- encoding : utf-8 -*-
class SurveyController < ApplicationController
  respond_to :json, :only => :check_date

  before_filter :check_user_login
  before_filter :check_questions_params, :only => [:create]

  def new
    @questions = Question.includes(:answers)
    @presenter = SurveyQuestions.new(@questions)
  end

  def create
    questions = params[:questions]
    session[:birthday] = {:day => params[:day], :month => params[:month], :year => params[:year]}
    session[:questions] = questions
    profiles = ProfileBuilder.profiles_given_questions(questions)
    profile_points = ProfileBuilder.build_profiles_points(profiles)
    session[:profile_points] = profile_points
    redirect_to new_user_registration_path
  end

  def check_date
    error_message = "A data informada é inválida" if is_date_invalid?(params)
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
