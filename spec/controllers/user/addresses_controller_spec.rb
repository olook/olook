# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ::User::AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { {:state => 'SP', :street => 'Rua Junes', :number => 123, :zip_code => '37876-197', :neighborhood => 'Centro', :telephone => '(35)3453-9848' } }
  let(:address) { FactoryGirl.create(:address, :user => user)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "should assigns @addresses" do
      get 'index'
      assigns(:addresses).should eq(user.addresses)
    end
  end

  describe "GET new" do
    it "should assigns @address" do
      get 'new'
      assigns(:address).should be_a_new(Address)
    end
  end

  describe "GET edit" do
    it "should assigns @address" do
      get 'edit', :id => address.id
      assigns(:address).should eq(address)
    end
  end

  describe "POST create" do
    it "should create a new address" do
      expect {
        post :create, :address => attributes
      }.to change(Address, :count).by(1)
    end
  end

  describe "PUT update" do
    it "should updates an address" do
      updated_attr = { :street => 'Rua Jones' }
      put :update, :id => address.id, :address => updated_attr
      Address.find(address.id).street.should eql('Rua Jones')
    end
  end

  describe "DELETE destroy" do
    it "should delete an address"do
      delete :destroy, :id => address.id
      Address.all.empty?.should be_true
    end
  end
end
