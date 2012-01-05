# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PagesController do

  let(:contact_information) { FactoryGirl.create(:contact_information)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'welcome'" do
    context "with a logged user" do
      it "should be successful" do
        user = Factory :user
        sign_in user
        get 'welcome'
        response.should be_success
      end
    end

    context "without a logged user" do
      it "should be redirected to login" do
        get 'welcome'
        response.should redirect_to new_user_session_path
      end
    end
  end

  describe "GET contact" do
    it "should assigns @contact_form" do
      get :contact
      assigns(:contact_form).should be_an_instance_of(ContactForm)
    end
  end

  describe "GET how_to" do
    it "should be succesul" do
      get :how_to
      response.should be_success
    end
  end

  describe "POST send_contact" do
    it "should send contact message" do
      form_attrs = { :email => "john@doe.com", :subject => contact_information.id, :message => "Lorem ipsum foo b4z!" }
      post :send_contact, :contact_form => form_attrs
      response.code.should == '302'
    end
  end
end
