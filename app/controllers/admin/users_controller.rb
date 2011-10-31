class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  respond_to :html

  def index
    @users = User.all
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
end
