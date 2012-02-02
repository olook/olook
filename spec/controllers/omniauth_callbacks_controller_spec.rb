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
        user.stub(:set_uid_and_facebook_token).with(omniauth)
        user.stub(:authenticatable_salt)
        get :facebook
        response.should redirect_to(member_showroom_path)
      end

      it "should set facebook uid and token" do
        User.stub(:find_for_facebook_oauth).and_return(user = mock_model(User))
        user.should_receive(:set_uid_and_facebook_token).with(omniauth)
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
      it "should set facebook uid and token" do
        User.any_instance.should_receive(:set_uid_and_facebook_token).with(omniauth)
        get :facebook
        response.should redirect_to(member_showroom_path)
        flash[:notice].should eq("Facebook Connect adicionado com sucesso")
      end

      it "should not set facebook uid and token when already exist a facebook account" do
        FactoryGirl.create(:user, :uid => "123")
        get :facebook
        response.should redirect_to(member_showroom_path)
        flash[:notice].should eq("Esta conta do Facebook já está em uso")
      end
    end
  end
end
