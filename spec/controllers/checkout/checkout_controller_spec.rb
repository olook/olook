# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CheckoutController do

  let(:user) { FactoryGirl.create :user }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_without_items) { FactoryGirl.create(:clean_cart, :user => user) }
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

    it "assigns a new checkout instance with empty address and payment" do
      get :new
      assigns[:checkout].should_not be_nil
      assigns[:checkout].address.should_not be_nil
      assigns[:checkout].payment.should_not be_nil
    end

    context "when user has address" do
      before :all do
        FactoryGirl.create(:address, {user: user})
      end

      it "assigns an addresses instance with user addresses" do
        get :new
        assigns[:addresses].should_not be_nil
        assigns[:addresses].count.should eq(1)
      end
    end
  end

  describe "#shipping_address" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    context "when user chooses an existing address" do
      let!(:address) { FactoryGirl.create(:address) }

      it "returns the address when the id is correct" do
        result = subject.send :shipping_address, {checkout: {}, address: {id: address.id}}
        result.should eq(address)
      end

      it "returns nil when the id is incorrect" do
        result = subject.send :shipping_address, {checkout: {}, address: {id: "incorrect"}}
        result.should be_nil
      end
    end
  end

end
