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
    redirect_to friends_home_path if @user.has_facebook? && session[:should_request_new_facebook_token].nil?
  end

  def home
  end

  def update_survey_question
  end

  def update_friends_list
  end

  def post_wall
    @facebook_adapter.post_wall_message(I18n.t('facebook.post_wall', :message => params[:message], :link => @user.invitation_url)) ? (head :ok) : (head :error)
  end

  def post_survey_answer
    @facebook_adapter.post_wall_message(I18n.t('facebook.answer_survey', :link => @user.invitation_url),
                                                                         :target => params[:survey][:friend_uid]) ? (head :ok) : (head :error)
  end

  def post_invite
    @facebook_adapter.post_wall_message(I18n.t('facebook.invite', :name => @user.name, :link => @user.invitation_url),
                                                                  :target => params[:friend_uid]) ? (head :ok) : (head :error)
  end

  private

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
