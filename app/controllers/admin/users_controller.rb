# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::BaseController

  load_and_authorize_resource

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

  def destroy
    @user = User.find(params[:id])
    @user.destroy
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

  def admin_login
    if sign_in User.find(params[:id]), :bypass => true
      redirect_to(member_showroom_path) 
    end
  end

  def lock_access
    @user = User.find(params[:id])
    @user.lock_access!
    redirect_to :action => :show
  end

  def unlock_access
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    end
    redirect_to :action => :show
  end

  # TO DO - Change transaction validation to CreditService class / Should move this validation to CreditService Class
  def create_credit_transaction
    @user = User.find(params[:id])
    if params[:value].to_i > 0
      Credit.add(params[:value].to_i, @user, nil, "Added by #{current_admin.name}", params[:reason])
    elsif params[:value].to_i < 0
      Credit.remove(params[:value].to_i.abs ,@user, nil, "Removed by #{current_admin.name}", params[:reason])
    end
    redirect_to (admin_user_path(@user))
  end

end
