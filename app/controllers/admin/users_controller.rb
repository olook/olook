# -*- encoding : utf-8 -*-
class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  respond_to :html, :text

  def index
    filter = User.where('')
    unless params[:search].blank?
      filter = filter.where('(first_name LIKE :search) OR (last_name LIKE :search) OR (email LIKE :search)',
                            :search => "%#{params[:search]}%")
    end
    @users = filter.page(params[:page]).per_page(15)
    respond_with :admin, @users
  end

  def show
    @user = User.find(params[:id])
    survey_answers_parser = SurveyAnswerParser.new(@user.survey_answers)
    @survey_answers = survey_answers_parser.build_survey_answers
    respond_with :admin, @user
  end

  def edit
    @user = User.find(params[:id])
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
    end

    respond_with :admin, @user
  end
  
  def export
    @records = UserReport.export
    respond_with :admin, @records
  end
  
  def statistics
    @statistics = UserReport.statistics
    respond_with :admin, @statistics
  end
end
