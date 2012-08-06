# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CheckoutController do
  let(:attributes) {{}}
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user).id }
  
  let(:user) { FactoryGirl.create :user }
  let(:cpf) { "06723914651" }
  
  let(:attributes) {{"user_name"=>"Joao", "credit_card_number"=>"1111222233334444", "security_code"=>"456", "user_birthday"=>"28/01/1987", "expiration_date"=>"01/14", "user_identification"=>"067.239.146-51", "telephone"=>"(35)7648-6749", "payments"=>"1", "bank"=>"Visa", "receipt" => "AVista" }}

  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user).id }

  let(:attributes) {{"bank"=>"BancoDoBrasil", "receipt" => Payment::RECEIPT}}
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user).id }

  before :each do
    user.update_attributes(:cpf => "19762003691")
    FactoryGirl.create(:line_item, :order => Order.find(order))
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  before :each do
    user.update_attributes(:cpf => "19762003691")
    FactoryGirl.create(:line_item, :order => Order.find(order))
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  pending "PUT update" do
    it "should updates the CPF" do
      User.any_instance.should_receive(:update_attributes).with(:cpf => cpf)
      put :update, :id => user.id, :user => {:cpf => cpf}
    end

    it "should not updates the CPF when already has one" do
      user.update_attributes(:cpf => cpf)
      User.any_instance.should_not_receive(:update_attributes).with(:cpf => cpf)
      put :update, :id => user.id, :user => {:cpf => cpf}
    end
  end

  before :each do
    user.update_attributes(:cpf => "19762003691")
    request.env['devise.mapping'] = Devise.mappings[:user]
    FactoryGirl.create(:line_item, :order => Order.find(order))
    sign_in user
  end

  pending "GET new" do
    before :each do
     session[:order] = order
    end

    context "with a valid order" do
      it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(Billet)
      end

      it "should redirect payments_path if the user dont have a cpf or is invalid" do
        user.update_attributes(:cpf => "11111111111")
        get :new
        response.should redirect_to(payments_path)
      end

      it "should not redirect payments_path if the user have a cpf" do
        get :new
        response.should_not redirect_to(payments_path)
      end
    end

    context "with a invalid order" do
      it "should redirect to cart path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to cart path if the order total with freight is less then 5.00" do
        Order.any_instance.stub(:line_items).and_return([])
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
        # CartPresenter.should_receive(:new).with(Order.find(order))
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

  pending "POST create" do
    before :each do
      session[:order] = order
      @order = Order.find(order)
      @processed_payment = OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(Billet))
    end

    describe "with some variant unavailable" do
      it "redirects to cath path" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
        post :create, :billet => attributes
        response.should redirect_to(cart_path)
      end
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :billet => attributes
      end

      it "should add the user for a campaing if requested" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        expect {
          post :create, :billet => attributes , :campaing => {:sign_campaing => 'foobar'}
        }.to change(user.campaing_participants, :count).by(1)
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :billet => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
      end

      it "should redirect to order_billet_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(processed_payment = @processed_payment)
        post :create, :billet => attributes
        session.should redirect_to(order_billet_path(:number => @order.number))
      end

      it "should assign @cart" do
        # CartPresenter.should_receive(:new).with(Order.find(order))
        get 'new'
      end
    end

    describe "with invalid params" do
      before :each do
        processed_payment = OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(Billet))
        payment_builder = mock
        payment_builder.stub(:process!).and_return(processed_payment)
        PaymentBuilder.stub(:new).and_return(payment_builder)
      end

      it "should render new template" do
        post :create, :billet => attributes
        response.should render_template('new')
      end
    end
  end

  pending "GET new" do
    before :each do
      session[:order] = order
    end

    context "with a valid order" do
      it "creates new credit card using user data" do
        CreditCard.should_receive(:user_data).with(user)
        get 'new'
      end

      it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(CreditCard)
      end

      it "should not redirect to cart_path if the total is greater then minimum" do
        Order.any_instance.stub(:amount_paid).and_return(CreditCard::MINIMUM_PAYMENT + 1)
        get 'new'
        response.should_not redirect_to(cart_path)
      end

      it "should redirect payments_path if the user dont have a cpf or is invalid" do
        user.update_attributes(:cpf => "12312312345")
        get :new
        response.should redirect_to(payments_path)
      end

      it "should not redirect payments_path if the user have a cpf" do
        get :new
        response.should_not redirect_to(payments_path)
      end
    end

    context "with a invalid order" do
      it "should redirect to root path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to cart path if the order dont have line items" do
        Order.any_instance.stub(:line_items).and_return([])
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
        # CartPresenter.should_receive(:new).with(Order.find(order))
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

  pending "POST create" do
    before :each do
      session[:order] = order
      @order = Order.find(order)
      @processed_payment = OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(CreditCard))
    end

    describe "with some variant unavailable" do
      it "redirect to cath path" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
        post :create, :credit_card => attributes
        response.should redirect_to(cart_path)
      end
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :credit_card => attributes
      end

      it "should add the user for a campaing if requested" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        expect {
          post :create, :credit_card => attributes , :campaing => {:sign_campaing => 'foobar'}
        }.to change(user.campaing_participants, :count).by(1)
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :credit_card => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
       end

      it "should redirect to payment order_credit_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(credit_card = @processed_payment)
        post :create, :credit_card => attributes
        response.should redirect_to(order_credit_path(:number => @order.number))
      end

      it "should assign @cart" do
        # CartPresenter.should_receive(:new).with(Order.find(order))
        post :create, :credit_card => {}
      end

      it "assigns @bank with previously selected bank" do
        post :create, :credit_card => { :bank => "Bamerindus" }
        assigns(:bank).should == "Bamerindus"
      end

      it "assigns @installment with previously selected installment" do
        post :create, :credit_card => { :payments => "n vezes sem juros" }
        assigns(:installments).should == "n vezes sem juros"
      end
    end

    describe "with invalid params" do
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

      it "should not create a payment" do
        CreditCard.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :credit_card => {}
        }.to change(CreditCard, :count).by(0)
      end

      it "should assign @cart" do
        # CartPresenter.should_receive(:new).with(Order.find(order))
        post :create, :credit_card => {}
      end
    end
  end

  pending "GET new" do
    before :each do
      session[:order] = order
    end

    context "with a valid order" do
     it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(Debit)
      end

      it "should redirect payments_path if the user dont have a cpf or is invalid" do
        user.update_attributes(:cpf => "12345678912")
        get :new
        response.should redirect_to(payments_path)
      end

      it "should not redirect payments_path if the user have a cpf" do
        get :new
        response.should_not redirect_to(payments_path)
      end
    end

    context "with a invalid order" do
      it "should redirect to cart path if the order is nil" do
        session[:order] = nil
        get 'new'
        response.should redirect_to(cart_path)
      end

      it "should redirect to cart path if the order dont have line items" do
        Order.any_instance.stub(:line_items).and_return([])
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
        # CartPresenter.should_receive(:new).with(Order.find(order))
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

  pending "POST create" do
    before :each do
      session[:order] = order
      @order = Order.find(order)
      @processed_payment = OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(Debit))
    end

    describe "with some variant unavailable" do
      it "redirect to cath path" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
        post :create, :debit => attributes
        response.should redirect_to(cart_path)
      end
    end

    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :debit => attributes
      end

      it "should add the user for a campaing if requested" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        expect {
          post :create, :debit => attributes , :campaing => {:sign_campaing => 'foobar'}
        }.to change(user.campaing_participants, :count).by(1)
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(@processed_payment)
        post :create, :debit => attributes
        session[:order].should be_nil
        session[:freight].should be_nil
        session[:delivery_address_id].should be_nil
      end

      it "should redirect to order_debit_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(debit = @processed_payment)
        post :create, :debit => attributes
        response.should redirect_to(order_debit_path(:number => @order.number))
      end

      it "should assign @cart" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(debit = @processed_payment)
        # CartPresenter.should_receive(:new).with(Order.find(order))
        post :create, :debit => attributes
      end
    end

    describe "with invalid params" do
      before :each do
        processed_payment = OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(Debit))
        payment_builder = mock
        payment_builder.stub(:process!).and_return(processed_payment)
        PaymentBuilder.stub(:new).and_return(payment_builder)
      end

      it "should render new" do
        post :create
        response.should render_template("new")
      end
    end
  end
end
