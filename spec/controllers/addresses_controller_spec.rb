# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { {:country => 'BRA', :state => 'MG', :street => 'Rua Jonas', :number => 123, :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848' } }

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
end
