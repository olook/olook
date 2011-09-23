class SurveyController < ApplicationController
  def index
    @questions = Question.all
  end

  def create
  end

end
