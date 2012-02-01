class FriendsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :initialize_facebook_adapter
  before_filter :load_not_registered_friends, :only => [:home, :update_survey_question]
  before_filter :load_friend, :only => [:home, :update_survey_question]
  before_filter :load_friends, :only => [:showroom, :home, :update_friends_list]

  def showroom
    @products = []
    15.times { @products << Product.all.shuffle.first }
  end

  def home
    questions = Question.includes(:answers)
    survey_questions = SurveyQuestions.new(questions)
    @question = survey_questions.common_questions.shuffle.first
  end

  def update_survey_question
    questions = Question.includes(:answers)
    survey_questions = SurveyQuestions.new(questions)
    @question = survey_questions.common_questions.shuffle.first
  end

  def update_friends_list
  end

  def post_wall
    @facebook_adapter.post_wall_message(params[:message]) ? (head :ok) : (head :error)
  end

  def post_survey_answer
    @facebook_adapter.post_wall_message("#{rand(10000)} quiz", :target => params[:survey][:friend_uid]) ? (head :ok) : (head :error)
  end

  def post_invite
    @facebook_adapter.post_wall_message("#{rand(10000)} post invite", :target => params[:friend_uid]) ? (head :ok) : (head :error)
  end

  private

  def load_friends
    @friends = @facebook_adapter.facebook_friends_registered_at_olook
  end

  def load_friend
    @friend = @not_registred_friends.shuffle.first
  end

  def load_not_registered_friends
    @not_registred_friends = @facebook_adapter.facebook_friends_not_registered_at_olook
  end

  def initialize_facebook_adapter
    @facebook_adapter = FacebookAdapter.new @user.facebook_token
  end
end
