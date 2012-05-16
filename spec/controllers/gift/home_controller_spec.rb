# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Gift::HomeController do

  let(:user) { FactoryGirl.create :user }
  let(:facebook_scopes) { "friends_birthday,publish_stream" }

  describe "GET 'index'" do
    it "returns http success" do
      sign_in user
      get 'index'
      response.should be_success
    end
  end

  describe "facebook connect" do
    it "should set session to redirect after facebook connect" do
      session[:facebook_redirect_paths] = nil
      get :index
      session[:facebook_redirect_paths].should == "gift"
    end
  end

  describe "GET 'update_birthdays_by_month'" do
    context "when facebook adapter is not available" do
      it "assigns nil to @frinds" do
        xhr :get, 'update_birthdays_by_month'
        assigns(:friends).should be_nil
        response.should be_success
      end
    end
  end

end
