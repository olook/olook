#encoding: utf-8
class JoinController < ApplicationController
  include Devise::Controllers::Rememberable
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
      remember_me(@user) unless params[:remeber_me].blank?
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      user_from_newsletter? params[:email]
      render :new
    end
  end

  private

    def user_from_newsletter? email
      newsletter_user = CampaignEmail.where(converted_user: false, email: params[:email]).first
      @user = User.new
      if newsletter_user
        @user.errors.add(:base, I18n.t("join_controller.create.newsletter_fail"))
      else
        @user.errors.add(:base, I18n.t("join_controller.create.fail"))
      end
    end

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
