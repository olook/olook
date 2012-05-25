# -*- encoding : utf-8 -*-
class Gift::SurveyController < Gift::BaseController
  before_filter :load_recipient
  
  def new
    if @gift_recipient
      @questions = Question.from_gift_survey
      @presenter = GiftSurveyQuestions.new(@questions)
    else
      redirect_to gift_root_path
    end
  end

  def create
    questions = params[:questions]
    if questions.present? && @gift_recipient
      @gift_recipient.update_attributes!(:ranked_profile_ids => ProfileBuilder.ordered_profiles(questions))
      redirect_to edit_gift_recipient_path(@gift_recipient)
    else
      redirect_to new_gift_survey_path
    end
  end
  
  private
  
  def load_recipient
    @gift_recipient = GiftRecipient.find(session[:recipient_id]) if session[:recipient_id].present?
  end

end
