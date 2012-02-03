require 'spec_helper'

describe FriendsController do
  with_a_logged_user do
    render_views
    let(:message) { "my message" }
    let(:attachment) do
      {:picture => "cdn.olook.com.br/assets/socialmedia/facebook/icon-app/app.jpg",
       :caption => "www.olook.com.br",
       :description => I18n.t('facebook.post_wall', :link => user.invitation_url),
       :link => "#{user.invitation_url}" }
    end


    describe "GET home" do
      it "should assign @questions" do
        FacebookAdapter.stub(:new).with(user.facebook_token).and_return(fb_adapter = stub)
        fb_adapter.stub(:friends_structure).and_return([[],[], ])
        question = FactoryGirl.create(:question)
        SurveyQuestions.should_receive(:new).with([question]).and_return(survey_questions = mock)
        survey_questions.should_receive(:common_questions).and_return([question])
        get :home
        assigns(:question).should eq(question)
      end
    end

    describe "POST post_wall" do
      context "on success" do
        before :each do
          FacebookAdapter.stub(:new).with(user.facebook_token).and_return(@fb_adapter = mock)
        end

        it "should post a message in the facebook wall" do
          @fb_adapter.should_receive(:post_wall_message).with(message, :attachment => attachment).and_return(true)
          post :post_wall, :message => message
        end

        it "should return a success response" do
          @fb_adapter.should_receive(:post_wall_message).with(message, :attachment => attachment).and_return(true)
          post :post_wall, :message => message
          response.should be_success
        end
      end

     context "on failure" do
       it "should return a failure response" do
         FacebookAdapter.stub(:new).with(user.facebook_token).and_return(fb_adapter = mock)
         fb_adapter.should_receive(:post_wall_message).with(message, :attachment => attachment).and_return(false)
         post :post_wall, :message => message
         response.should_not be_success
       end
     end
    end
  end
end
