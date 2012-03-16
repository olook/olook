# -*- encoding : utf-8 -*-
class User::SettingsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user

  def showroom
    @questions = Question.includes(:answers)
    @presenter = SurveyQuestions.new(@questions)
  end

  def update_info
    current_user.user_info.update_attributes(params[:user_info])
    redirect_to "/conta/minha-vitrine"
  end

end
