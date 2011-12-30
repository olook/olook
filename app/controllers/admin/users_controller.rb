# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::BaseController
  respond_to :html, :text

  def index
    @search = User.search(params[:search])
    @users = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
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

  def statistics
    @statistics = UserReport.statistics
    respond_with :admin, @statistics
  end

  def export
    Resque.enqueue(Admin::ExportUsersWorker, current_admin.email)
  end
end
