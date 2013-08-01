require 'spec_helper'

describe QuizController do

  describe "GET 'new'" do
    before do
      WhatsYourStyle::Quiz.any_instance.stub(:quiz).and_return({ })
    end
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
