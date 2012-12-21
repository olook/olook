# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do

  let(:cart) {mock_model(Cart, id: 1)}
  let(:product) { FactoryGirl.create(:basic_shoe) }
  context "#create" do
    context "adding a new item to the users cart" do
      it "adds an item with quantity = 1" do
        session[:cart_id] = cart.id
        post :create, variant_id: 1
      end
    end

    context "adding an existing item to the users cart" do
      it "increases the item quantity" do
        pending
      end
    end

  end

  context "#destroy" do
    it "removes a given item from the users cart" do
      pending
    end
  end

end