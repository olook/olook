class SurveyController < ApplicationController
  def index
    @questions = Question.all
  end

  def create
    questions = params[:questions]
    session[:questions] = questions
    profiles = Profile.profiles_given_questions(questions)
    profile_points = Profile.build_profiles_points(profiles)     
    session[:profile_points] = profile_points
  end
end
