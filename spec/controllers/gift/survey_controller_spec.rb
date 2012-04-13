require 'spec_helper'

describe Gift::SurveyController do
  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  
  before do
    session[:recipient_id] = recipient.id
  end
  
  describe "GET 'new'" do
    let(:questions) { [ FactoryGirl.create(:question) ]}
    
    context "when no gift recipient is found in the session" do
      it "redirects to new_survey" do
        session[:recipient_id] = nil
        post 'new'
        response.should redirect_to new_gift_survey_path
      end
    end
    
    it "find the recipient by id and assigns to @recipient" do
      GiftRecipient.should_receive(:find).with(session[:recipient_id]).and_return(recipient)
      get 'new'
      assigns(:recipient).should == recipient 
    end
    
    context "with the recipient found" do
      before do
        GiftRecipient.stub(:find).and_return(recipient)
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
  end

  describe "POST 'create'" do
    let(:questions) {  [{"foo" => "bar"}, {"baz" => "bar"}]  }
    let(:ordered_profiles) { [3,2,1] }

    context "when no questions param is received" do
      it "redirects to new_survey" do
        post 'create'
        response.should redirect_to new_gift_survey_path
      end
    end

    context "when questions param is received and the recipient is found" do
      
      before do
        GiftRecipient.stub(:find).and_return(recipient)
      end

      context "when no gift recipient is found in the session" do
        it "redirects to new_survey" do
          session[:recipient_id] = nil
          post 'create', :questions => questions
          response.should redirect_to new_gift_survey_path
        end
      end

      context "when an existing gift recipient is found in the session" do
        before do
          session[:recipient_id] = recipient.id
        end
        
        it "find the recipient by id and assigns to @recipient" do
          ProfileBuilder.stub(:ordered_profiles).and_return(ordered_profiles)
          
          GiftRecipient.should_receive(:find).with(session[:recipient_id]).and_return(recipient)
          post 'create', :questions => questions
          assigns(:recipient).should == recipient 
        end

        it "keeps the questions and answers in the session" do
          ProfileBuilder.stub(:ordered_profiles).and_return(ordered_profiles)

          post 'create', :questions => questions
          session[:questions].should == questions
        end

        it "keeps the recipient profiles in the session" do
          ProfileBuilder.should_receive(:ordered_profiles).and_return(ordered_profiles)

          post 'create', :questions => questions
          session[:recipient_profiles].should == ordered_profiles
        end

        it "redirects to new recipient path" do
          ProfileBuilder.stub(:ordered_profiles).and_return(ordered_profiles)

          post 'create', :questions => questions
          response.should redirect_to new_gift_recipient_path
        end
      end
      
    end
  end

end
