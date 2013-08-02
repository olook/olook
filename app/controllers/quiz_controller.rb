class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle::Quiz.new
  end

  def create
    # params[:whats_your_style_quiz][:name]
    # params[:whats_your_style_quiz][:questions]
  end
end
