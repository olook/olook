# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { {:state => 'MG', :street => 'Rua Jonas', :number => 123, :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848' } }
  let(:address) { FactoryGirl.create(:address, :user => user)}
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:freight) {{ "price" => 1.99 }}

  before :each do
    session[:order] = order
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET new" do
    it "should assigns @address" do
      get 'new'
      assigns(:address).should be_a_new(Address)
    end

    it "should assign @cart" do
      Cart.should_receive(:new).with(order)
      get 'new'
    end
  end

  describe "POST create" do
    context "with valid a address" do
      it "should create a address" do
        expect {
          post :create, :address => attributes
        }.to change(Address, :count).by(1)
      end

      it "should assign the address id in the session" do
        post :create, :address => attributes
        session[:delivery_address_id].should == Address.all.last.id
      end

      it "should assign the address id in the session" do
        post :create, :address => attributes
        session[:freight].should_not be(nil)
      end

      it "should assign the freight in the session" do
        freight_data = {:price => 12.95, :cost => 2.99, :delivery_time => 1}
        FreightCalculator.stub(:freight_for_zip).and_return(freight_data)
        post :create, :address => attributes
        session[:freight].should == freight_data
      end
    end
  end

  describe "POST assign_address" do
    context "with a valid address" do
      it "should assign the delivery_address_id in the session" do
        post :assign_address, :delivery_address_id => address.id
        session[:delivery_address_id].should == address.id
      end

      it "should assign the delivery_address_id in the session" do
        post :assign_address, :delivery_address_id => address.id
        session[:delivery_address_id].should == address.id
      end

      it "should assign the delivery_address_id in the session" do
        post :assign_address, :delivery_address_id => address.id
        session[:delivery_address_id].should == address.id
      end

      it "should assign the freight in the session" do
        freight_data = {:price => 12.95, :cost => 2.99, :delivery_time => 1}
        FreightCalculator.stub(:freight_for_zip).and_return(freight_data)
        post :assign_address, :delivery_address_id => address.id
        session[:freight].should == freight_data
      end

      it "should redirect to payments" do
        post :assign_address, :delivery_address_id => address.id
        response.should redirect_to(payments_path)
      end
    end

    context "with a valid address" do
      it "should redirect to address_path" do
        fake_address_id = "99999"
        post :assign_address, :delivery_address_id => fake_address_id
        response.should redirect_to(addresses_path)
      end
    end
  end
end
