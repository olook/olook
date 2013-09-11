#encoding: utf-8
class JoinController < ApplicationController
  include Devise::Controllers::Rememberable
  layout 'quiz'

  before_filter do
    @hide_about_quiz = true
  end

  def new
    set_user_already_variable
    @user = User.new
    @user.email = cookies['newsletterEmail']
    @quiz_count = User.full
  end

  def register
    set_user_already_variable
    @user = User.new(params[:user])
    if @user.save
      sign_in(:user, @user)
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      @user_already_registered = User.where(email: params[:user][:email]).any?
      render :new
    end
  end

  def login
    @user = User.find_for_authentication(:email => params[:email])
    if @user && @user.valid_password?(params[:password])
      sign_in(@user)
      remember_me(@user) unless params[:remeber_me].blank?
      redirect_to set_user_profile(@user).next_step, notice: I18n.t("join_controller.create.success")
    else
      user_from_newsletter? params[:email]
      render :new
    end
  end

  def facebook_login
    saved, @user = User.find_or_create_with_fb_jssdk_data(params[:user])
    if saved
      sign_in(@user)
      render json: { next_step: set_user_profile(@user).next_step }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def showroom
    @user = User.new
    render layout: 'lite_application'
  end

  private

    def set_user_already_variable
      @user_already_registered = false
    end

    def user_from_newsletter? email
      newsletter_user = CampaignEmail.where(converted_user: false, email: params[:email]).first
      @user = User.new
      if newsletter_user
        @user.email = newsletter_user.email
        @exist_newsletter = true
        @user.errors.add(:base, I18n.t("join_controller.create.newsletter_fail"))
      else
        @user.errors.add(:base, I18n.t("join_controller.create.fail"))
      end
    end

    def load_quiz_responder
      params[:qr_uuid]
    end

    def set_user_profile(user)
      if load_quiz_responder
        @qr = QuizResponder.find(params[:qr_uuid])
        @qr.user = user
        @qr.validate!
        @qr
      else
        QuizResponder.new(user)
      end
    end
end
