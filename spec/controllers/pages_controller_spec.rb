# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PagesController do

  let(:contact_information) { FactoryGirl.create(:contact_information) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET contact" do
    it "should assigns @contact_form" do
      get :contact
      assigns(:contact_form).should be_an_instance_of(ContactForm)
    end
  end

  describe "GET how_to" do
    it "should be successful" do
      get :how_to
      response.should be_success
    end
  end

  describe "GET press" do
    it "should be successfull" do
      get :press
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

  describe "GET return_policy" do
    it "should be successful" do
      get :return_policy
      response.should be_success
    end
  end
end
