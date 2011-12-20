# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OmniauthCallbacksController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "without a logged user" do
    describe "GET facebook" do
      before :each do
        controller.stub!(:current_user).and_return(nil)
      end
      it "should redirect to showroom page if authentication is successful" do
        User.stub(:find_for_facebook_oauth).and_return(user = mock_model(User))
        user.stub(:authenticatable_salt)
        get :facebook
        response.should redirect_to(member_showroom_path)
      end

      it "should redirect to register new user page if authentication fails" do
        User.stub(:find_for_facebook_oauth).and_return(nil)
        get :facebook
        response.should redirect_to(new_user_registration_path)
      end
    end
  end

  describe "with a logged user" do
    describe "GET facebook" do
      before :each do
        controller.stub!(:current_user).and_return(@user = mock_model(User))
      end
      it "should set facebook uid and token" do
        controller.env["omniauth.auth"] = {"extra" => {"user_hash" => {"id" => "123"}}, "credentials" => {"token" => "token"}}
        @user.should_receive(:update_attributes).with(:uid => "123", :facebook_token => "token")
        get :facebook
        response.should redirect_to(member_showroom_path, :notice => "Facebook Connect adicionado com sucesso")
      end

      it "should not set facebook uid and token when already exist a facebook account" do
        controller.env["omniauth.auth"] = {"extra" => {"user_hash" => {"id" => "123"}}, "credentials" => {"token" => "token"}}
        FactoryGirl.create(:user, :uid => "123")
        get :facebook
        response.should redirect_to(member_showroom_path, :notice => "Esta conta do Facebook já está em uso")
      end
    end
  end
end
