class QuizController < ApplicationController
  layout 'quiz'
  def new
    @quiz = Quiz.new.questions
  end
end
