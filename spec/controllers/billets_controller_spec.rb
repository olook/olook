# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BilletsController do
  let(:attributes) {{}}
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    sign_in user
  end

  describe "GET show" do
    it "should assign a @payment" do
      order = FactoryGirl.create(:order, :user => user)
      payment = order.payment
      get :show, :id => payment.id
    end
  end

  describe "GET new" do
    context "with a valid order" do
      before :each do
        order = double
        order.stub(:reload)
        session[:order] = order
      end
      it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(Billet)
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
      it "should redirect to root path" do
        get 'new'
        response.should redirect_to(root_path)
      end
    end
  end

  describe "POST create" do
    before :each do
      order = double
      order.stub(:reload)
      session[:order] = order
    end
    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(Billet))
        post :create, :billet => attributes
      end

      it "should clean the session order" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(mock_model(Billet))
        post :create, :billet => attributes
        session[:order].should be(nil)
      end

      it "should redirect to billet_path" do
        PaymentBuilder.stub(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(billet = mock_model(Billet))
        post :create, :billet => attributes
        session.should redirect_to(billet_path(billet))
      end
    end

    describe "with invalid params" do
      it "should not create a payment" do
        Billet.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :billet => {}
        }.to change(Billet, :count).by(0)
      end
    end
  end
end
