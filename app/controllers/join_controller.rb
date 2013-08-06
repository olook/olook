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
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      render :new
    end
  end

  private
    def load_quiz_responder
      @quiz_responder = session[:qr]
    end

    def set_user_profile(user)
      load_quiz_responder
      @qr = QuizResponder.find(@quiz_responder[:uuid])
      @qr.user = user
      @qr.validate!
      @qr
    end
end
