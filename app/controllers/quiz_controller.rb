class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle::Quiz.new
  end
end
