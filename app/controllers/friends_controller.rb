class FriendsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :initialize_facebook_adapter
  before_filter :load_friends, :only => [:showroom, :home, :update_friends_list, :update_survey_question]
  before_filter :load_question, :only => [:home, :update_survey_question]

  def showroom
    @friend = User.find(params[:friend_id])
    @products = @friend.all_profiles_showroom
  end

  def facebook_connect
    if user_can_access_friends_page
      redirect_to friends_home_path
    else
      session[:should_request_new_facebook_token] = true
    end
  end

  def home
  end

  def update_survey_question
  end

  def update_friends_list
  end

  def post_wall
    attachment = {
      :picture => "cdn.olook.com.br/assets/socialmedia/facebook/icon-app/app.jpg",
      :caption => "www.olook.com.br",
      :description => I18n.t('facebook.post_wall', :link => @user.invitation_url),
      :link => "#{@user.invitation_url}" }
    @facebook_adapter.post_wall_message(params[:message], :attachment => attachment ) ? (head :ok) : (head :error)
  end

  def post_survey_answer
    @facebook_adapter.post_wall_message(I18n.t('facebook.answer_survey', :link => @user.invitation_url),
                                                                         :target => params[:survey][:friend_uid]) ? (head :ok) : (head :error)
  end

  def post_invite
    @facebook_adapter.post_wall_message(I18n.t('facebook.invite', :link => @user.invitation_url),
                                                                  :target => params[:friend_uid]) ? (head :ok) : (head :error)
  end

  private

  def user_can_access_friends_page
    @user.has_facebook? && session[:should_request_new_facebook_token].nil?
  end

  def load_question
    questions = Question.includes(:answers)
    survey_questions = SurveyQuestions.new(questions)
    @question = survey_questions.common_questions.shuffle.first
  end

  def load_friends
    @not_registred_friends, @friends, @friend = @facebook_adapter.friends_structure
  end

  def initialize_facebook_adapter
    @facebook_adapter = FacebookAdapter.new @user.facebook_token
  end
end
