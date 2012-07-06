# -*- encoding : utf-8 -*-
class User::SettingsController < ApplicationController
  layout "my_account"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :redirect_if_half_user, :only => [:showroom]

  def showroom
    @questions = Question.from_registration_survey
    @presenter = SurveyQuestions.new(@questions)
  end

  def update_info
    current_user.user_info.update_attributes(params[:user_info])
    redirect_to "/conta/minha-vitrine"
  end

  protected
  def redirect_if_half_user
    if current_user.half_user
      redirect_to lookbooks_path
    end
  end
  

end
