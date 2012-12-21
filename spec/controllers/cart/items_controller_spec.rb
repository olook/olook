# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do

  let(:cart_item) {FactoryGirl.create(:cart_item_that_belongs_to_a_cart)} #{mock_model(CartItem, :order => order)}
  context "#create" do
    it "adds a new item to the users cart" do
      session[:cart_id] = cart_item.cart.id
    end
  end

  context "#destroy" do
    it "removes a given item from the users cart" do

    end
  end

end