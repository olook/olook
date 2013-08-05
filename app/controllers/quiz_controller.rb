class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle::Quiz.new
  end

  def create
    params[:quiz] = {
      name: "Whats your style?",
      questions: {"3"=>"9", "1"=>"3", "21"=>"84", "10"=>"38", "20"=>"79", "7"=>"25", "11"=>"44", "13"=>"50", "12"=>"46", "8"=>"32", "18"=>"69", "5"=>"18"}
    }
    @quiz_responder = QuizResponder.new(params[:quiz])
    @quiz_responder.user = current_user
    @quiz_responder.validate!
    if @quiz_responder.save_session?
      session[:qr] = @quiz_responder.session_data
    end
    redirect_to @quiz_responder.next_step
  end
end
