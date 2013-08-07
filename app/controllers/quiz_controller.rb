class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle::Quiz.new
  end

  def create
    @quiz_responder = QuizResponder.new(params[:quiz])
    @quiz_responder.user = current_user
    @quiz_responder.validate!
    if @quiz_responder.save_session?
      session[:qr] = @quiz_responder.session_data
    end
    redirect_to @quiz_responder.next_step
  end
end
