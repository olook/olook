# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PaymentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:payment) { FactoryGirl.create(:billet, :order => order) }
  let(:total) { 99.55 }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET show" do
    it "should assigns @payment" do
      get :show, :id => payment.id
      assigns(:payment).should == payment
    end
  end

  describe "POST create" do
    before :each do
      Order.any_instance.stub(:total_with_freight).and_return(total)
    end

    context "with valids params" do
     it "should return 200" do
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id, :value => total
        response.status.should == 200
      end

      it "should change the payment status to billet_printed" do
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id, :value => total
        order.payment.reload.billet_printed?.should eq(true)
      end

      it "should change the order status to completed" do
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id, :value => total
        authorized = "1"
        post :create, :status_pagamento => authorized, :id_transacao => order.id, :value => total
        completed = "4"
        post :create, :status_pagamento => completed, :id_transacao => order.id, :value => total
        Order.find(order.id).completed?.should eq(true)
      end
    end

    context "with invalids params" do
      it "should return 500 with a invalid status" do
        invalid_status = "0"
        post :create, :status_pagamento => invalid_status, :id_transacao => order.id, :value => total
        response.status.should == 500
      end

      it "should return 500 with a invalid value" do
        invalid_total = "9999"
        billet_printed = "3"
        post :create, :status_pagamento => billet_printed, :id_transacao => order.id, :value => invalid_total
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

      it "should redirect to cart path if the order total is less then 0" do
        order.stub(:total).and_return(0)
        session[:order] = order
        get 'index'
        response.should redirect_to(cart_path)
      end
    end

    context "with a valid freight" do
      it "should assign @freight" do
        get 'index'
        assigns(:freight).should == order.freight
      end

      it "should assign @cart" do
        session[:order] = order
        Cart.should_receive(:new).with(order)
        get 'index'
      end
    end

    context "with a invalid freight" do
      it "assign redirect to address_path" do
        order.stub(:freight).and_return(nil)
        get 'index'
        response.should redirect_to(addresses_path)
      end
    end
  end
 end
