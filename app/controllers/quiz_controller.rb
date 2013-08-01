class QuizController < ApplicationController
  layout 'quiz'
  def new
    @questions = WhatsYourStyle::Quiz.new.questions
  end
end
