require 'spec_helper'

describe Gift::SurveyController do

  describe "GET 'new'" do
    let(:questions) { [ FactoryGirl.create(:question) ]}

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "gets all questions and answers from gift survey and assigns to question" do
      Question.should_receive(:from_gift_survey).and_return(questions)
      get 'new'
      assigns(:questions).should eq questions
    end

    it "instantiates @presenter with survey questions" do
      presenter = double(:presenter)
      Question.stub(:from_gift_survey).and_return(questions)
      GiftSurveyQuestions.should_receive(:new).with(questions).and_return(presenter)
      get 'new'
      assigns(:presenter).should eq presenter
    end

  end

  describe "POST 'create'" do
    let(:questions) {  [{"foo" => "bar"}, {"baz" => "bar"}]  }

    context "when no questions param is received" do
      it "redirects to new_survey" do
        post 'create'
        response.should redirect_to new_gift_survey_path
      end
    end

    context "when questions param is received" do
      it "keeps the questions and answers in the session" do
        ProfileBuilder.stub(:first_profile_given_questions).and_return("Elegante")

        post 'create', :questions => questions
        session[:questions].should == questions
      end

      it "assigns recipient profile with the first profile given the questions" do
        ProfileBuilder.should_receive(:first_profile_given_questions).and_return("Elegante")

        post 'create', :questions => questions
        assigns(:recipient_profile).should eq "Elegante"
      end
    end
  end

end
