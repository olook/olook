class WhatsYourStyleController < ApplicationController
  layout 'wysquiz'
  def new
    @quiz = WhatsYourStyle.new.quiz
  end
end
