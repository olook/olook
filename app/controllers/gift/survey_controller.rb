class Gift::SurveyController < Gift::BaseController
  def new
    @questions = Question.from_gift_survey
    @presenter = GiftSurveyQuestions.new(@questions)
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
