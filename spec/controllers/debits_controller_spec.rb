# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DebitsController do
  let(:attributes) {{"bank"=>"BancoDoBrasil", "receipt" => Payment::RECEIPT}}
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET show" do
    it "should assign a @payment" do
      payment = order.payment
      get :show, :id => payment.id
      assigns(:payment).should == payment
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
        assigns(:freight).should == order.freight
      end

      it "should assign @cart" do
        Cart.should_receive(:new).with(order)
        get 'new'
      end
    end

    context "with a invalid freight" do
      it "assign redirect to address_path" do
        order.stub(:freight).and_return(nil)
        get 'new'
        response.should redirect_to(addresses_path)
      end
    end
  end

  describe "POST create" do
    before :each do
      session[:order] = order
      @processed_payment = OpenStruct.new(:status => "Sucesso", :payment => mock_model(Debit))
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :debit => attributes
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :debit => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
      end

      it "should redirect to debit_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(debit = @processed_payment)
        post :create, :debit => attributes
        response.should redirect_to(debit_path(debit.payment))
      end

      it "should assign @cart" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(debit = @processed_payment)
        Cart.should_receive(:new).with(order)
        post :create, :debit => attributes
      end
    end

    describe "with invalid params" do
      it "should not create a payment" do
        Debit.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create
        }.to change(Debit, :count).by(0)
      end

      it "should render new" do
        post :create
        response.should render_template("new")
      end
    end
  end
end
