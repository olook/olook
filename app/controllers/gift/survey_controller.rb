# -*- encoding : utf-8 -*-
class Gift::SurveyController < Gift::BaseController
  def new
    @questions = Question.from_gift_survey
    @presenter = GiftSurveyQuestions.new(@questions)
    # get gift recipient relation (amiga, mãe, namorada, etc) to use on questions (and create a helper)
  end

  def create
    questions = params[:questions]
    recipient_id = session[:recipient_id]
    recipient = GiftRecipient.find(recipient_id) if recipient_id
    if questions.present? && recipient.present?
      session[:questions] = questions
      session[:recipient_profiles] = ProfileBuilder.ordered_profiles(questions)
      redirect_to new_gift_recipient_path
    else
      redirect_to new_gift_survey_path
    end
  end

end
