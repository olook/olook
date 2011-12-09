# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ::AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { {:state => 'MG', :street => 'Rua Jonas', :number => 123, :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848' } }
  let(:order) { FactoryGirl.create(:order, :user => user).id }

  before :each do
    FactoryGirl.create(:line_item, :order => Order.find(order))
    session[:order] = order
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
    @address = FactoryGirl.create(:address, :user => user)
  end

  describe "GET index" do
    it "should assign @cart" do
      Cart.should_receive(:new).with(Order.find(order))
      get :index
    end

    it "should assign @address" do
      get :index
      assigns(:addresses).should eq(user.addresses)
    end

    it "should redirect cart_path if the user dont have a cpf" do
      user.update_attributes(:cpf => nil)
      get :index
      response.should redirect_to(cart_path)
    end

    it "should not redirect cart_path if the user have a cpf" do
      get :index
      response.should_not redirect_to(cart_path)
    end
  end

  describe "GET new" do
    it "should assigns @address" do
      get 'new'
      assigns(:address).should be_a_new(Address)
    end

    it "should assign @cart" do
      Cart.should_receive(:new).with(Order.find(order))
      get 'new'
    end
  end

  describe "POST create" do
    context "with valid a address" do
      before :each do
        freight = {:price => 12.34, :cost => 2.34, :delivery_time => 2}
        FreightCalculator.stub(:freight_for_zip).and_return(freight)
      end

      it "should create a address" do
        expect {
          post :create, :address => attributes
        }.to change(Address, :count).by(1)
      end

      it "should redirect to payments_path" do
         post :create, :address => attributes
         response.should redirect_to(payments_path)
      end

      it "should assign @cart" do
        Cart.should_receive(:new).with(Order.find(order))
        post :create, :address => attributes
      end

      context "when the order already have a freight" do
        it "should update the freight" do
          expect {
            post :create, :address => attributes
          }.to change(Freight, :count).by(0)
        end
      end

      context "when the order dont have a freight" do
        it "should create a feight" do
          Order.find(order).freight.destroy
          expect{
            post :create, :address => attributes
          }.to change(Freight, :count).by(1)
        end
      end
    end
  end

  describe "GET edit" do
    it "should assigns @address" do
      get 'edit', :id => @address.id
      assigns(:address).should eq(@address)
    end
  end

  describe "PUT update" do
    it "should updates an address" do
      updated_attr = { :street => 'Rua Jones' }
      put :update, :id => @address.id, :address => updated_attr
      Address.find(@address.id).street.should eql('Rua Jones')
    end
  end

  describe "DELETE destroy" do
    it "should delete an address"do
      expect {
        delete :destroy, :id => @address.id
      }.to change(Address, :count).by(-1)
    end

    it "should delete a order freight if it has the destroyed address"do
      Order.find(order).freight.update_attributes(:address_id => @address.id)
      expect {
        delete :destroy, :id => @address.id
      }.to change(Freight, :count).by(-1)
    end
  end

  describe "POST assign_address" do
    context "with a valid address" do
      before :each do
        freight = {:price => 12.34, :cost => 2.34, :delivery_time => 2}
        FreightCalculator.stub(:freight_for_zip).and_return(freight)
      end

      context "when the order already have a freight" do
        it "should update the freight" do
          expect {
            post :assign_address, :delivery_address_id => @address.id
          }.to change(Freight, :count).by(0)
        end
      end

      context "when the order dont have a freight" do
        it "should create a feight" do
          Order.find(order).freight.destroy
          expect{
            post :assign_address, :delivery_address_id => @address.id
          }.to change(Freight, :count).by(1)
        end
      end

      it "should redirect to payments" do
        post :assign_address, :delivery_address_id => @address.id
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
