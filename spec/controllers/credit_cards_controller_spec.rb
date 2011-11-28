# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CreditCardsController do
  let(:attributes) {{"user_name"=>"Joao", "credit_card_number"=>"1111222233334444", "security_code"=>"456", "user_birthday"=>"27/89/1986", "expiration_date"=>"22/14", "user_identification"=>"067.239.146-51", "telephone"=>"(35)7648-6749", "payments"=>"1", "bank"=>"Visa", "receipt" => "AVista" }}

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

  describe "GET new" do
    before :each do
      session[:order] = order
    end
    context "with a valid order" do
      it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(CreditCard)
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
      it "should redirect to root path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to root path if the order is nil" do
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
      session[:freight] = {:price => 12}
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(CreditCard))
        post :create, :credit_card => attributes
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(CreditCard))
        post :create, :credit_card => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
       end

      it "should redirect to credit card path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(credit_card = mock_model(CreditCard))
        post :create, :credit_card => attributes
        response.should redirect_to(credit_card_path(credit_card))
      end

      it "should assign @payment" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(credit_card = mock_model(CreditCard))
        post :create, :credit_card => attributes
        assigns(:payment).should eq(credit_card)
      end
    end

    describe "with invalid params" do
      it "should not create a payment" do
        CreditCard.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :credit_card => {}
        }.to change(CreditCard, :count).by(0)
      end
    end
  end
end
