class SurveyController < ApplicationController

  before_filter :check_user_login

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
end
