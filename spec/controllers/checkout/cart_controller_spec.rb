# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CartController do
  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:user) { FactoryGirl.create(:user) }
  let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }

  before :each do
    session[:cart_id] = cart.id
    session[:cart_freight] = mock
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  after :each do
    session[:cart_id] = nil
    session[:cart_coupon] = nil
    session[:cart_freight] = nil
  end

  it "should erase freight when call any action" do
    session[:cart_freight] = mock
    ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i} 
    Product.stub(:find).with(ids).and_return(nil)
    get :show
    assigns(:cart_service).freight.should be_nil
    assigns(:report).should_not be_nil
  end

  context "when show" do
    it "should render show view" do
      ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i} 
      Product.stub(:find).with(ids).and_return(nil)
      get :show
      response.should render_template ["layouts/site", "show"]
    end
  end

  context "when destroy" do
    it "should remove cart in database" do
      Cart.any_instance.should_receive(:destroy)
      delete :destroy
      response.should redirect_to(cart_path)
      flash[:notice].should eql("Sua sacola está vazia")
    end

    it "should reset session params" do
      delete :destroy
      session[:cart_id].should be_nil
      session[:cart_coupon].should be_nil
      session[:cart_freight].should be_nil
    end

    it "should set flash notice" do
      delete :destroy
      flash[:notice].should eql("Sua sacola está vazia")
    end

    it "should redirect to cart" do
      delete :destroy
      response.should redirect_to(cart_path)
    end
  end

  context "when update" do

    context "when item removed and respond for html" do
      before :each do
        Cart.any_instance
            .stub(:remove_item)
            .with(basic_bag)
            .and_return(true)
      end
    end

    context "when item is not removed and respond for html" do
      before :each do
        Cart.any_instance
            .stub(:remove_item)
            .with(basic_bag)
            .and_return(false)
      end
    end
  end

  describe "PUT#update", js: true do 

    context "when update gift wrap" do
      it "should update cart" do
        params = {cart: {gift_wrap: "true"}, format: :js}
        put :update, params
        cart.reload.gift_wrap.should eq(true)
      end

      it "should render template update" do
        params = {cart: {gift_wrap: "true"}, format: :js}
        put :update, params
        response.should render_template ["update"]
      end
    end

    context "when update coupon" do
      it "should update cart" do
        Cart.any_instance.should_receive(:update_attributes).with({"coupon_code" => "CODE"}).and_return(true)
        put :update, {cart: {coupon_code: "CODE"}, format: :js}
      end

      it "should render template update" do
        Cart.any_instance.should_receive(:update_attributes).with({"coupon_code" => "CODE"}).and_return(true)
        put :update, {cart: {coupon_code: "CODE"}, format: :js}
        response.should render_template ["update"]
      end

    end
  end

end

