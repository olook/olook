require 'spec_helper'

describe FriendsController do
  with_a_logged_user do
    render_views
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
    let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
    let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }
    let(:message) { "my message" }
    let(:facebook_scopes) { "friends_birthday,publish_stream" }
    let(:attachment) do
      {:picture => "cdn.olook.com.br/assets/socialmedia/facebook/icon-app/app-2012-09-19.jpg",
       :caption => "www.olook.com.br",
       :description => I18n.t('facebook.post_wall', :link => user.invitation_url),
       :link => "http://www.olook.com.br/#{ wysquiz_path }" }
    end

    describe "GET facebook_connect" do
      it "should redirect to friends page when the user can access facebook extended permissions was not setted" do
        User.any_instance.stub(:can_access_facebook_extended_features?).and_return(true)
        get :facebook_connect
        response.should redirect_to(friends_home_path)
      end

      it "should not redirect to friends page when the user dont have a facebook extended permission" do
        User.any_instance.stub(:can_access_facebook_extended_features?).and_return(false)
        get :facebook_connect
        response.should_not redirect_to(friends_home_path)
      end

      it "should set session to redirect after facebook connect" do
        session[:facebook_redirect_paths] = nil
        User.any_instance.stub(:can_access_facebook_extended_features?).and_return(false)
        get :facebook_connect
        session[:facebook_redirect_paths].should == "friends"
      end
    end

    describe "GET home" do
      let!(:question) { FactoryGirl.create(:question) }

      before :each do
        FacebookAdapter.stub(:new).with(user.facebook_token).and_return(fb_adapter = stub)
        fb_adapter.stub(:friends_structure).and_return(friends_structure = [[], [], ])
        SurveyQuestions.stub(:new).with([question]).and_return(survey_questions = mock)
        survey_questions.stub(:questions_for_my_friends_quiz).and_return([question])
        User.any_instance.stub(:can_access_facebook_extended_features?).and_return(true)
        session[:facebook_scopes] = nil
      end

      it "gets all questions from the registration survey" do
        Question.should_receive(:from_registration_survey).and_return([question])
        get :home
      end

      it "should assign @questions" do
        get :home
        assigns(:question).should eq(question)
      end

      it "should assign friends structure" do
        get :home
        assigns(:not_registred_friends).should == []
        assigns(:friends).should == []
        assigns(:friend).should be_nil
      end

      it "should redirect to facebook_connect_path if the user dont have extended permission" do
        User.any_instance.stub(:can_access_facebook_extended_features?).and_return(false)
        get :home
        response.should redirect_to(facebook_connect_path)
      end

      it "should redirect to facebook_connect_path if session[:facebook_scopes] was setted" do
        session[:facebook_scopes] = facebook_scopes
        get :home
        response.should redirect_to(facebook_connect_path)
      end
    end

    context "POST actions" do
      before :each do
        FacebookAdapter.stub(:new).with(user.facebook_token).and_return(@fb_adapter = mock)
      end

      describe "POST post_survey_answer" do
        context "on success" do
          it "should post a survey answer" do
            friend_uid = "100"
            @fb_adapter.should_receive(:post_wall_message).
              with(I18n.t('facebook.answer_survey', :name => user.name, :link => user.invitation_url), :target => friend_uid).and_return(true)
            post :post_survey_answer, :survey => {:friend_uid => friend_uid}
          end

          it "should return a successful response" do
            friend_uid = "100"
            @fb_adapter.stub(:post_wall_message).and_return(true)
            post :post_survey_answer, :survey => {:friend_uid => friend_uid}
            response.should be_success
          end
        end

        context "on failure" do
          it "should return a failure response" do
            friend_uid = "100"
            @fb_adapter.stub(:post_wall_message).and_return(false)
            post :post_survey_answer, :survey => {:friend_uid => friend_uid}
            response.should_not be_success
          end
        end
      end

      describe "POST post_invite" do
        context "on success" do
          it "should post a invite" do
            friend_uid = "100"
            @fb_adapter.should_receive(:post_wall_message).
              with(I18n.t('facebook.invite', :link => user.invitation_url), :target => friend_uid).and_return(true)
            post :post_invite, :friend_uid => friend_uid
          end

          it "should return a successful response" do
            friend_uid = "100"
            @fb_adapter.stub(:post_wall_message).and_return(true)
            post :post_invite, :friend_uid => friend_uid
            response.should be_success
          end
        end

        context "on failure" do
          it "should return a failure response" do
            friend_uid = "100"
            @fb_adapter.stub(:post_wall_message).and_return(false)
            post :post_invite, :friend_uid => friend_uid
            response.should_not be_success
          end
        end
      end

      describe "POST post_wall" do
        context "on success" do
          it "should post a message in the facebook wall" do
            @fb_adapter.should_receive(:post_wall_message).with(message, :attachment => attachment).and_return(true)
            post :post_wall, :message => message
          end

          it "should return a successful response" do
            @fb_adapter.should_receive(:post_wall_message).with(message, :attachment => attachment).and_return(true)
            post :post_wall, :message => message
            response.should be_success
          end
        end

       context "on failure" do
         it "should return a failure response" do
           FacebookAdapter.stub(:new).with(user.facebook_token).and_return(fb_adapter = mock)
           fb_adapter.should_receive(:post_wall_message).and_return(false)
           post :post_wall, :message => message
           response.should_not be_success
         end
       end
      end
    end
  end
end
