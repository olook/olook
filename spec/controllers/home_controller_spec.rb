# -*- encoding : utf-8 -*-
require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    let(:standard_params) { {'controller' => 'home_controller', 'action' => 'index', 'tracking_xyz' => 'test'} }
    let(:tracked_params) { {'tracking_xyz' => 'test'} }
    let(:facebook_scopes) { "friends_birthday,publish_stream" }


    it "should be successful" do
      get 'index'
      response.should be_success
    end

    context "User facebook sharing" do
      let(:point) { FactoryGirl.create(:point) }
      let(:profile) { point.user.profile_scores.first.try(:profile).first_visit_banner }
      let(:sharing_params) { {'share' => 'share', 'uid' => point.user.id.to_s } }

      it "assigning @user of the current id" do
        get 'index', sharing_params
        assigns(:user).should eq(point.user)
      end

      it "assigning @profile with visit_banner of the current @user" do
        get 'index', sharing_params
        assigns(:profile).should eq(profile)
      end

      it "assigning @qualities of the current @profile" do
        get 'index', sharing_params
        assigns(:qualities).should eq(Profile::DESCRIPTION["#{profile}"])
      end

      it "assigning @url of the current environment" do
        get 'index', sharing_params
        assigns(:url).should eq( request.protocol + request.host )
      end

    end

    context "tracking params" do

      context "when some tracking params are passed" do
        it "saves tracking params in the session" do
          get 'index', standard_params
          subject.session[:tracking_params].should == {'tracking_xyz' => 'test'}
        end
      end

      context "when some tracking params were already set in session" do
        let(:old_params) { {'tracking_abc' => 'testing'} }
        before do
          subject.session[:tracking_params] = old_params
        end

        it "does not overwrite the old params" do
          get 'index', standard_params
          subject.session[:tracking_params].should == old_params
        end
      end
    end

    context "redirecting to members showroom" do
      context "when user is signed in" do
        it "redirects to member showroom" do
          subject.stub(:'user_signed_in?').and_return(true)
          subject.should_not_receive(:redirect_to)
          get 'index', standard_params
        end
      end

      context "when user is not signed in" do
        it "does not redirect to member showroom" do
          subject.stub(:'user_signed_in?').and_return(false)
          subject.should_not_receive(:redirect_to)
          get 'index', :params => standard_params
        end
      end

    end

  end

end
