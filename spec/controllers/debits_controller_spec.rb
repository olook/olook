# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DebitsController do
  let(:attributes) {{"bank"=>"BancoDoBrasil"}}
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:freight) {{ "price" => 1.99 }}
  let(:order) { FactoryGirl.create(:order, :user => user) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    session[:freight] = freight
    sign_in user
  end

  describe "GET show" do
    it "should assign a @payment" do
      debit = FactoryGirl.create(:debit)
      order = FactoryGirl.create(:order, :user => user, :payment => debit)
      get :show, :id => debit.id
    end
  end

  describe "GET new" do
    before :each do
      session[:order] = order
    end

    context "with a valid order" do
     it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(Debit)
      end

      it "should assigns @delivery_address from the session" do
        get 'new'
        assigns(:delivery_address).should eq(address)
      end

      it "should redirect to new_payment_path if the delivery_address_id is nil" do
        session[:delivery_address_id] = nil
        get 'new'
        response.should redirect_to(addresses_path)
      end
    end

    context "with a invalid order" do
      it "should redirect to cart path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to cart path if the order total is less then 0" do
        order.stub(:total).and_return(0)
        session[:order] = order
        get 'new'
        response.should redirect_to(cart_path)
      end
    end

    context "with a valid freight" do
      it "should assign @freight" do
        get 'new'
        assigns(:freight).should == freight
      end

      it "should assign @cart" do
        session[:order] = order
        Cart.should_receive(:new).with(order, freight)
        get 'new'
      end
    end

    context "with a invalid freight" do
      it "assign redirect to address_path" do
        session[:freight] = nil
        get 'new'
        response.should redirect_to(addresses_path)
      end
    end
  end

  describe "POST create" do
    before :each do
      session[:order] = order
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(Debit))
        post :create, :debit => attributes
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(Debit))
        post :create, :debit => attributes
        session[:order].should be(nil)
      end

      it "should redirect to debit_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(debit = mock_model(Debit))
        post :create, :debit => attributes
        response.should redirect_to(debit_path(debit))
      end
    end

    describe "with invalid params" do
      it "should not create a payment" do
        Debit.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :debit => {}
        }.to change(Debit, :count).by(0)
      end
    end
  end
end
