class JoinController < ApplicationController
  layout 'quiz'

  before_filter do
    @hide_about_quiz = true
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(:user, @user)
      redirect_to profile_path, notice: I18n.t("join_controller.create.success")
    else
      render :new
    end
  end

end
