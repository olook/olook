class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle::Quiz.new
  end

  def create
    @quiz_responder = QuizResponder.new(params[:quiz])
    @quiz_responder.user = current_user
    if @quiz_responder.next_step == 'profile'
      redirect_to profile_path
    else
      render text: 'NEED USER LOGIN OR SIGN UP PATH'
    end
  end
end
