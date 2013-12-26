# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CheckoutController do

  let(:user) { FactoryGirl.create(:user, :cpf => "47952756370")}
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_without_items) { FactoryGirl.create(:clean_cart, :user => user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }

  subject { described_class.new}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  after :each do
    session[:cart_id] = nil
  end

  it "should redirect user to login when is offline" do
    get :new
    response.should redirect_to(new_user_session_path)
  end

  context "checking" do
    before :each do
      sign_in user
    end

    it "redirects to cart_path when cart is empty" do
      session[:cart_id] = nil
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end

    it "removes unavailabe items" do
      session[:cart_id] = cart.id
      Cart.any_instance.should_receive(:remove_unavailable_items).and_return(true)
      get :new
    end

    it "redirects to cart_path when cart items is empty" do
      session[:cart_id] = cart_without_items.id
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end

  end

  describe "#new" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    it "redirects to new checkout template" do
      get :new
      response.should be_success
    end

    it "assigns a new checkout instance with address nil and payment nil" do
      get :new
      assigns[:checkout].should_not be_nil
      assigns[:checkout].address.should be_nil
      assigns[:checkout].payment.should be_nil
    end

    context "when user has address" do
      before :each do
        FactoryGirl.create(:address, {user: user})
        FreightCalculator.stub(:freight_for_zip).and_return({default_shipping: {}, fast_shipping: {}})
      end

      it "renders the template new" do
        get :new
        response.should render_template("new")
      end

      it "assigns an addresses instance with user addresses" do
        get :new
        assigns[:addresses].should_not be_nil
        assigns[:addresses].count.should eq(1)
      end
    end
  end

  describe "PUT#create" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    context "when user chooses inexistent address" do
      let(:invalid_data) { {checkout: {payment: {}}, address: {id: "inexistent"}} }

      it "renders new template" do
        put :create, invalid_data
        response.should render_template("new")
      end
      it "returns null address" do
        put :create, invalid_data
        assigns[:checkout].address.should_not be_nil
        assigns[:checkout].address.id.should be_nil
      end
    end

    context "when user gives invalid address information for a new address" do
      let(:invalid_data) { {checkout: {address: {street: "street_name", number: 123}, payment: {}}} }

      it "renders new template" do
        put :create, invalid_data
        response.should render_template("new")
      end

      it "returns given information of the address" do
        put :create, invalid_data
        assigns[:checkout].address.id.should eq(nil)
        assigns[:checkout].address.street.should eq("street_name")
        assigns[:checkout].address.number.should eq(123)
      end
    end

    context "when user gives invalid address information for an existing address" do
      let(:invalid_data) { {checkout: {address: {id: address.id, street: "street_name", number: 123}, payment: {}}} }

      it "renders new template" do
        put :create, invalid_data
        response.should render_template("new")
      end

      it "returns given information of the address" do
        put :create, invalid_data
        assigns[:checkout].address.id.should eq(address.id)
        assigns[:checkout].address.street.should eq("street_name")
        assigns[:checkout].address.number.should eq(123)
      end
    end

    context "when user gives invalid payment data" do
      let(:invalid_data) { {checkout: {payment: {credit_card_number: "0000000000000001"}, payment_method: "credit_card"}, address: {id: address.id}} }

      it "renders new template" do
        put :create, invalid_data
        response.should render_template("new")
      end

      it "returns given information of the payment" do
        put :create, invalid_data
        assigns[:checkout].payment.credit_card_number.should eq("0000000000000001")
      end
    end

    context "when user gives valid debit data" do
      let(:valid_data) { {checkout: {payment: {bank: "Itau"}, payment_method: "debit"}, address: {id: address.id}} }

      it "redirects to order show in case of success" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should redirect_to(order_show_path(number: 123))
      end

      it "cleans cart id from session" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        session[:cart_id].should eq(nil)
      end

      it "renders new in case of error" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::FAILURE_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should render_template("new")
      end
    end

    context "when user gives valid billet data" do
      let(:valid_data) { {checkout: {payment: {}, payment_method: "billet"}, address: {id: address.id}} }

      it "redirects to order show in case of success" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should redirect_to(order_show_path(number: 123))
      end

      it "cleans cart id from session" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        session[:cart_id].should eq(nil)
      end

      it "renders new in case of error" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::FAILURE_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should render_template("new")
      end
    end

    context "when user gives valid credit_card data" do
      let(:valid_data) { {checkout: {
                            payment: {
                              bank: "VISA", 
                              payments: "1", 
                              user_name: "Frederico", 
                              credit_card_number: "0000000000000000", 
                              security_code: "123", 
                              expiration_date: "11/99", 
                              user_identification: "47952756370", 
                              user_birthday: "01/01/1980"}, 
                            payment_method: "credit_card"}, 
                          address: {id: address.id}} 
                        }

      it "redirects to order show in case of success" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should redirect_to(order_show_path(number: 123))
      end

      it "cleans cart id from session" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::SUCCESSFUL_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        session[:cart_id].should eq(nil)
      end

      it "renders new in case of error" do
        sender_strategy_mock = mock
        payment_builder_mock = mock
        PaymentService.should_receive(:create_sender_strategy).and_return(sender_strategy_mock)
        PaymentBuilder.should_receive(:new).and_return(payment_builder_mock)
        payment_builder_mock.should_receive(:process!).and_return(OpenStruct.new(status: Payment::FAILURE_STATUS, payment: OpenStruct.new({order: OpenStruct.new({number: 123})})))
        put :create, valid_data
        response.should render_template("new")
      end
    end

  end

end
