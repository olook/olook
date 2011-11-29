# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PaymentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order) }
  let(:freight) {{ "price" => 1.99 }}
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { FactoryGirl.create(:billet, :order => order) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    session[:freight] = freight
    sign_in user
  end

  describe "GET show" do
    it "should assigns @payment" do
      get :show, :id => payment.id
      assigns(:payment).should == payment
    end
  end

  describe "POST create" do
    context "with valids params" do
      it "should return 200" do
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id
        response.status.should == 200
      end

      it "should change the payment status to billet_printed" do
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id
        order.payment.reload.billet_printed?.should eq(true)
      end
    end

    context "with invalids params" do
      it "should return 500" do
        invalid_status = "0"
        post :create, :status_pagamento => invalid_status, :id_transacao => order.id
        response.status.should == 500
      end
    end
  end

  describe "GET index" do
    before :each do
      session[:order] = order
    end

    context "with a valid order" do
      it "should be success" do
        get 'index'
        response.should be_successful
      end
    end

    context "with a invalid order" do
      it "should redirect to root path if the order is nil" do
        session[:order] = nil
        get 'index'
        response.should redirect_to(cart_path)
      end

      it "should redirect to root path if the order is nil" do
        order.stub(:total).and_return(0)
        session[:order] = order
        get 'index'
        response.should redirect_to(cart_path)
      end
    end

    context "with a empty address" do
      it "should redirect to root path" do
        session[:delivery_address_id] = nil
        get 'index'
        response.should redirect_to(addresses_path)
      end
    end

    context "with a valid freight" do
      it "should assign @freight" do
        get 'index'
        assigns(:freight).should == freight
      end

      it "should assign @cart" do
        session[:order] = order
        Cart.should_receive(:new).with(order, freight)
        get 'index'
      end
    end

    context "with a invalid freight" do
      it "assign redirect to address_path" do
        session[:freight] = nil
        get 'index'
        response.should redirect_to(addresses_path)
      end
    end
  end
 end
