class Gift::SurveyController < ApplicationController
  layout "gift"
  def new
    @questions = Question.from_gift_survey
    @presenter = GiftSurveyQuestions.new(@questions)
  end

  def create
    questions = params[:questions]
    if questions.present?
      session[:questions] = questions
      session[:recipient_profile] = ProfileBuilder.first_profile_given_questions(questions)
      redirect_to new_gift_recipient_path
    else
      redirect_to new_gift_survey_path
    end
  end

end
