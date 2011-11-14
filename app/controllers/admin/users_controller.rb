# -*- encoding : utf-8 -*-
class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  respond_to :html, :text

  def index
    @users = User.page(params[:page]).per_page(15)
    respond_with :admin, @users
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

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
    end

    respond_with :admin, @user
  end
  
  def export
    @records = User.all.map do |user|
      [ user.first_name,
        user.last_name,
        user.email,
        user.is_invited? ? 'invited' : 'organic',
        user.created_at.to_s(:short),
        user.profile_scores.first.try(:profile).try(:name),
        accept_invitation_url(:invite_token => user.invite_token),
        user.events.where(:type => EventType::TRACKING).first.try(:description)
      ]
    end
    respond_with :admin, @records
  end
end
