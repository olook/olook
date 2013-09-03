class QuizController < ApplicationController
  layout 'quiz'
  def new
    @email = cookies['newsletterEmail']
    @quiz = WhatsYourStyle::Quiz.new
  end

  def create
    @quiz_responder = QuizResponder.new(params[:quiz])
    @quiz_responder.user = current_user
    @quiz_responder.validate!
    redirect_to @quiz_responder.next_step
  end
end
