#encoding: utf-8
class JoinController < ApplicationController
  layout 'quiz'

  before_filter do
    @hide_about_quiz = true
  end

  def new
    @user = User.new
  end

  def register
    @user = User.new(params[:user])
    if @user.save
      sign_in(:user, @user)
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      render :new
    end
  end

  def login
    @user = User.find_for_authentication(:email => params[:email])
    if @user && @user.valid_password?(params[:password])
      sign_in(:user, @user)
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      @user = User.new
      @user.errors.add(:base, "Email ou Senha inválidos")
      render :new
    end
  end

  private
    def load_quiz_responder
      @quiz_responder = session[:qr]
    end

    def set_user_profile(user)
      if load_quiz_responder
        @qr = QuizResponder.find(@quiz_responder[:uuid])
        @qr.user = user
        @qr.validate!
        @qr
      else
         QuizResponder.new(user)
      end
    end
end
