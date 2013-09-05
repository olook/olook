# -*- encoding : utf-8 -*-
class SurveyController < ApplicationController
  respond_to :json, :only => :check_date

  before_filter :check_questions_params, :only => [:create]

  def new
    @questions = Question.from_registration_survey
    @presenter = SurveyQuestions.new(@questions)
  end

  def create
    questions = params[:questions]
    birthday = {:day => params[:day], :month => params[:month], :year => params[:year]}

    if !current_user
      session[:profile_questions] = questions
      session[:profile_birthday] = birthday
      redirect_to new_user_registration_path
    else
      session[:profile_retake] = ((current_user.points.count > 0) || current_user.survey_answer)

      current_user.points.delete_all if current_user.points.count > 0
      current_user.survey_answer.delete if current_user.survey_answer

      ProfileBuilder.factory(birthday, questions, current_user)
      current_user.upgrade_to_full_user!

      if session[:profile_retake]
        redirect_to member_showroom_path
      else
        redirect_to member_welcome_path
      end
    end
  end

  def check_date
    error_message = I18n.t 'errors.messages.invalid_date' if is_date_invalid?(params)
    respond_to do |format|
      format.json { render :json => { :message => error_message } }
    end
  end

  private

  def check_questions_params
    redirect_to wysquiz_path if (params[:questions].nil? || is_date_invalid?(params))
  end

  def is_date_invalid?(params)
    !Date.valid_date?(params[:year].to_i,params[:month].to_i,params[:day].to_i)
  end
end
