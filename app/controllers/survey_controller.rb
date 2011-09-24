class SurveyController < ApplicationController
  def index
    @questions = Question.all
  end

  def create
    @answers = params[:answers]
    @a = []

    @answers.each do |id|
      profile = Answer.find(id[1]).profile
      @a << profile
    end

#    @h = Hash.new
#
#    @a.each do |p|
#      @h[p] += 1
#    end
#
#    session[:profiles] = @h

  end

end
