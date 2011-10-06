class SurveyController < ApplicationController

  before_filter :check_user_login
  before_filter :check_questions_params, :only => [:create]

  def index
    @questions = Question.includes(:answers).each
  end

  def create
    questions = params[:questions]
    session[:questions] = questions
    profiles = Profile.profiles_given_questions(questions)
    profile_points = Profile.build_profiles_points(profiles)
    session[:profile_points] = profile_points
  end

  private

  def check_user_login
    redirect_to root_path if current_user
  end

  def check_questions_params
    redirect_to survey_index_path if params[:questions].nil?
  end
end
