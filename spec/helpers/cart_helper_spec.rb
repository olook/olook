# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartHelper do

  describe "#print_credit_message" do
    it "returns failed message" do
      @user = User.new
      @cart = Cart.new
      @cart.stub(:allow_credit_payment?).and_return(false)
      @cart_service = CartService.new({cart: @cart})
      helper.print_credit_message.should eq("(não podem ser utilizados em pedidos com desconto)")
    end

    it "returns nil" do
      @user = User.new
      @cart = Cart.new
      @cart.stub(:allow_credit_payment?).and_return(true)
      @cart_service = CartService.new({cart: @cart})
      helper.print_credit_message.should eq(nil)
    end
  end

  describe "#total_user_credits" do
    it "returns user's credits" do
      @user = User.new
      @cart = Cart.new
      @user.stub(:current_credit).and_return("10.00")
      @cart.stub(:allow_credit_payment?).and_return(true)
      @cart_service = CartService.new({cart: @cart})
      helper.total_user_credits.should eq(@user.current_credit)
    end

    it "returns user credits" do
      @cart = Cart.new
      @user = User.new
      @cart.stub(:allow_credit_payment?).and_return(false)
      @user.stub(:current_credit).and_return("10.00")
      @user.stub(:user_credits_for,:redeem).and_return(true)
      @user.user_credits_for(:redeem).stub(:total).and_return("20.00")
      @cart_service = CartService.new({cart: @cart})
      helper.total_user_credits.should eq("20.00")
    end
  end

end
