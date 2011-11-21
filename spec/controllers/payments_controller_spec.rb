# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PaymentsController do
  let(:attributes) {{"payment_type"=>Payment::TYPE[:billet], "user_name"=>"", "credit_card_number"=>"", "security_code"=>"", "user_birthday"=>"", "expiration_date"=>"", "user_identification"=>"", "telephone"=>"", "payments"=>"", "bank"=>"BancoDoBrasil"}}

  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    sign_in user
  end

  describe "GET new" do
    context "with a valid order" do
      before :each do
        session[:order] = :fake_order
      end
      it "should assigns @payment" do
        get 'new'
        assigns(:payment).should be_a_new(Payment)
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
      session[:order] = :fake_order
    end
    describe "with valid params" do
      it "should process the payment" do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!)
        post :create, :payment => attributes
      end
    end

    describe "with invalid params" do
      it "should not create a payment" do
        Payment.any_instance.stub(:valid?).and_return(false)
        expect {
          post :create, :payment => {}
        }.to change(Payment, :count).by(0)
      end
    end
  end
end
