# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CreditCardsController do
  let(:attributes) {{"user_name"=>"Joao", "credit_card_number"=>"1111222233334444", "security_code"=>"456", "user_birthday"=>"28/01/1987", "expiration_date"=>"01/14", "user_identification"=>"067.239.146-51", "telephone"=>"(35)7648-6749", "payments"=>"1", "bank"=>"Visa", "receipt" => "AVista" }}

  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user).id }

  before :each do
    FactoryGirl.create(:line_item, :order => Order.find(order))
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET show" do
    it "should assign a @payment" do
      payment = Order.find(order).payment
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
        assigns(:payment).should be_a_new(CreditCard)
      end
    end

    context "with a invalid order" do
      it "should redirect to root path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to cart path if the order total is less then 0" do
        Order.find(order).line_items.delete_all
        get 'new'
        response.should redirect_to(cart_path)
      end
    end

    context "with a valid freight" do
      it "should assign @freight" do
        get 'new'
        assigns(:freight).should == Order.find(order).freight
      end

      it "should assign @cart" do
        session[:order] = order
        Cart.should_receive(:new).with(Order.find(order))
        get 'new'
      end
    end

    context "with a invalid freight" do
      it "assign redirect to address_path" do
        Order.find(order).freight.destroy
        get 'new'
        response.should redirect_to(addresses_path)
      end
    end
  end

  describe "POST create" do
    before :each do
      session[:order] = order
      @processed_payment = OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(CreditCard))
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :credit_card => attributes
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :credit_card => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
       end

      it "should redirect to payment path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(credit_card = @processed_payment)
        post :create, :credit_card => attributes
        response.should redirect_to(payment_path(credit_card.payment))
      end

      it "should assign @cart" do
        Cart.should_receive(:new).with(Order.find(order))
        post :create, :credit_card => {}
      end
    end

    describe "with invalid params" do
      context "when a payment fail" do
        before :each do
          processed_payment = OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(CreditCard))
          payment_builder = mock
          payment_builder.stub(:process!).and_return(processed_payment)
          PaymentBuilder.stub(:new).and_return(payment_builder)
        end

        it "should render new template" do
          post :create, :credit_card => attributes
          response.should render_template('new')
        end

        it "should generate a identification code" do
          Order.any_instance.should_receive(:generate_identification_code)
          post :create, :credit_card => attributes
        end
      end

      it "should not create a payment" do
        CreditCard.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :credit_card => {}
        }.to change(CreditCard, :count).by(0)
      end

      it "should assign @cart" do
        Cart.should_receive(:new).with(Order.find(order))
        post :create, :credit_card => {}
      end
    end
  end
end
