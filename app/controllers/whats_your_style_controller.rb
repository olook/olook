class WhatsYourStyleController < ApplicationController
  def new
    url = URI.parse "http://whatsyourstyle.olook.com.br:9000/v1/quizzes/1?api_token=wmy47jY9_5ZwRWJKUHJ1ng" #TODO please move me to some constant into some class
    response = Net::HTTP.get_response(url)
    @quiz = HashWithIndifferentAccess.new(JSON.parse response.body)
  end
end
