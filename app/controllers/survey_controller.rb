class SurveyController < ApplicationController
  def index
    @questions = Question.all
  end

  def create
  	@questions = params[:questions]
  	
    
    @a = []

    @questions.each do |question_name, answer_id|
      profile = Answer.find(answer_id).profile
      @a << profile
    end

    @h = Hash.new

  
    @a.each do |p|
      @h[p.id] = (@h[p].nil?) ? 1 : @h[p] + 1 
    end

    debugger
    session[:profiles] = @h
  end

end
