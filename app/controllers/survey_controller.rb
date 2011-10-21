# -*- encoding : utf-8 -*-
class SurveyController < ApplicationController

  before_filter :check_user_login
  before_filter :check_questions_params, :only => [:create]

  def index
    @questions = Question.includes(:answers)
    @id_first_question = @questions.first.id if @questions.size > 0
  end

  def create
    questions = params[:questions]
    session[:questions] = questions
    profiles = ProfileBuilder.profiles_given_questions(questions)
    profile_points = ProfileBuilder.build_profiles_points(profiles)
    session[:profile_points] = profile_points
    redirect_to new_user_registration_path
  end

  private

  def check_user_login
    redirect_to root_path if current_user
  end

  def check_questions_params
    redirect_to survey_index_path if params[:questions].nil?
  end
end
