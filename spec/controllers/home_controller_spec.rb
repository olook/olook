# -*- encoding : utf-8 -*-
require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    let(:standard_params) { {'controller' => 'home_controller', 'action' => 'index', 'tracking_xyz' => 'test'} }
    let(:tracked_params) { {'tracking_xyz' => 'test'} }

    it "should be successful" do
      get 'index'
      response.should be_success
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

        it "does not subscribe the old params" do
          get 'index', standard_params
          subject.session[:tracking_params].should == old_params
        end
      end
    end

    context "redirecting to members showroom" do
      context "when user is signed in" do
        it "redirects to member showroom" do
          subject.stub(:'user_signed_in?').and_return(true)
          subject.should_receive(:redirect_to).with(member_showroom_path)
          get 'index', :params => standard_params
        end
      end

      context "when user is not signed in" do
        it "does not redirect to member showroom" do
          subject.stub(:'user_signed_in?').and_return(false)
          get 'index', :params => standard_params
          subject.should_not_receive(:redirect_to)
        end
      end

    end

  end

end
