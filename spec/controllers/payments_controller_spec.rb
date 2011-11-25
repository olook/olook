# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PaymentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    sign_in user
  end

  describe "POST create" do
    context "with valid params" do
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
  end

  describe "GET index" do
    context "with a valid order" do
      before :each do
        order = double
        order.stub(:reload)
        session[:order] = order
      end
      it "should be success" do
        get 'index'
        response.should be_successful
      end
    end

    context "with a invalid order" do
      it "should redirect to root path" do
        session[:order] = nil
        get 'index'
        response.should redirect_to(root_path)
      end
    end

    context "with a empty address" do
      it "should redirect to root path" do
        session[:delivery_address_id] = nil
        get 'index'
        response.should redirect_to(root_path)
      end
    end
  end
 end
