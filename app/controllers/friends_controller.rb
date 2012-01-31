class FriendsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :load_user

  def showroom
    assign_facebook_friends
    @products = []
    15.times { @products << Product.all.shuffle.first }
  end

  def home
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    @not_registred_friends = facebook_adapter.facebook_friends_not_registered_at_olook
    @friend  = @not_registred_friends.shuffle.first
    @friends = facebook_adapter.facebook_friends_registered_at_olook
    questions = Question.includes(:answers)
    survey_questions = SurveyQuestions.new(questions)
    @question = survey_questions.common_questions.shuffle.first
  end

  def update_survey_question
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    @not_registred_friends = facebook_adapter.facebook_friends_not_registered_at_olook
    @friend = @not_registred_friends.shuffle.first
    questions = Question.includes(:answers)
    survey_questions = SurveyQuestions.new(questions)
    @question = survey_questions.common_questions.shuffle.first
  end

  def update_friends_list
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    @friends = facebook_adapter.facebook_friends_registered_at_olook
  end

  def post_wall
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    facebook_adapter.post_wall_message(params[:message]) ? (head :ok) : (head :error)
  end

  def post_survey_answer
    facebook_adapter = FacebookAdapter.new @user.facebook_token
    facebook_adapter.post_wall_message("", :target => params[:survey][:friend_uid]) ? (head :ok) : (head :error)
  end

  private

  def assign_facebook_friends
    @friends = []
    7.times { @friends << User.where("id < ?", 100).shuffle.first }
  end
end
