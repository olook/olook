class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = WhatsYourStyle.new.quiz
  end
end
