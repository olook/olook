# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OmniauthCallbacksController do
  let(:omniauth) {{"extra" => {"user_hash" => {"id" => "123"}}, "credentials" => {"token" => "token"}}}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    controller.env["omniauth.auth"] = omniauth
  end

  describe "without a logged user" do
    describe "GET facebook" do
      it "should redirect to showroom page if authentication is successful" do
        User.stub(:find_for_facebook_oauth).and_return(user = mock_model(User))
        user.stub(:set_facebook_data).with(omniauth, session)
        user.stub(:authenticatable_salt)
        get :facebook
        response.should redirect_to(member_showroom_path)
      end

      it "should set facebook uid and token" do
        User.stub(:find_for_facebook_oauth).and_return(user = mock_model(User))
        user.should_receive(:set_facebook_data).with(omniauth, session)
        user.stub(:authenticatable_salt)
        get :facebook
      end

      it "should redirect to register new user page if authentication fails" do
        User.stub(:find_for_facebook_oauth).and_return(nil)
        get :facebook
        response.should redirect_to(new_user_registration_path)
      end
    end
  end

  with_a_logged_user do
    describe "GET facebook" do
      it "should set facebook data" do
        User.any_instance.should_receive(:set_facebook_data).with(omniauth, session)
        get :facebook
      end

      it "should redirect to member showroom" do
       User.any_instance.stub(:set_facebook_data)
        session[:facebook_scopes] = nil
        get :facebook
        response.should redirect_to(member_showroom_path)
      end

      it "should redirect to friends showroom" do
        User.any_instance.stub(:set_facebook_data)
        session[:facebook_scopes] = true
        get :facebook
        response.should redirect_to(friends_home_path)
      end

      it "should set nil to facebook_scopes" do
        session[:facebook_scopes] = true
        get :facebook
        session[:facebook_scopes].should be_nil
      end
    end
  end
end
