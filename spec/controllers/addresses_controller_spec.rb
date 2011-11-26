# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { {:state => 'MG', :street => 'Rua Jonas', :number => 123, :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848' } }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET new" do
    it "should assigns @address" do
      get 'new'
      assigns(:address).should be_a_new(Address)
    end
  end

  describe "POST create" do
    it "should create a address" do
      expect {
        post :create, :address => attributes
      }.to change(Address, :count).by(1)
    end
  end

  describe "POST create" do
    it "should assign the address id in the session" do
      post :create, :address => attributes
      session[:delivery_address_id].should == Address.all.last.id
    end
  end

  describe "POST assign_address" do
    it "should assign the delivery_address_id in the session" do
      fake_address_id = "1"
      post :assign_address, :delivery_address_id => fake_address_id
      session[:delivery_address_id].should == fake_address_id
    end

    it "should redirect to new payment" do
      post :assign_address
      response.should redirect_to(payments_path)
    end
  end
end
