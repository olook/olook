class WhatsYourStyleController < ApplicationController
  layout 'wysquiz'
  def new
    @quiz = Quiz::WhatsYourStyle.new.quiz
  end
end
