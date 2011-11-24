# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PaymentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, :user => user) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    session[:delivery_address_id] = address.id
    sign_in user
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
