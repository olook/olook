# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::AddressesController do

  let(:user) { FactoryGirl.create :user }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:attributes) { {:state => 'MG', :street => 'Rua Jonas', :number => 123, :city => 'São Paulo', :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848', :mobile => '(11)99877-8712' } }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_without_items) { FactoryGirl.create(:clean_cart, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:coupon_expired) do
    coupon = double(Coupon)
    coupon.stub(:reload)
    coupon.stub(:expired?).and_return(true)
    coupon.stub(:available?).and_return(false)
    coupon
  end
  let(:coupon_not_more_available) do
    coupon = double(Coupon)
    coupon.stub(:reload)
    coupon.stub(:expired?).and_return(false)
    coupon.stub(:available?).and_return(false)
    coupon
  end

  let(:freight) { {:price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id} }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    CartService.any_instance.stub(:cart_sub_total).and_return(60)
  end

  after :each do
    session[:cart_id] = nil
  end

  it "should redirect user to login when is offline" do
    get :index
    response.should redirect_to(new_user_session_path)
  end

  context "checking" do
    before :each do
      sign_in user
    end

    it "should redirect to cart_path when cart is empty" do
      session[:cart_id] = nil
      get :index
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end

    it "should remove unavailabe items" do
      session[:cart_id] = cart.id
      Cart.any_instance.should_receive(:remove_unavailable_items).and_return(true)
      get :index
    end

    it "should redirect to cart_path when cart items is empty" do
      session[:cart_id] = cart_without_items.id
      get :index
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end

  end

  context "GET index" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    it "should assign @address" do
      address.user.should eq(user)
      get :index
      assigns(:addresses).should eq([address])
    end

    it "should redirect to new if the user dont have an address" do
      get :index
      response.should redirect_to(new_checkout_address_url(protocol: 'https'))
    end
  end

  context "GET new" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    it "should assigns @address" do
      get 'new'
      assigns(:address).should be_a_new(Address)
    end

    it "should set first name" do
      get 'new'
      assigns(:address).first_name.should eq user.first_name
    end

    it "should set last name" do
      get 'new'
      assigns(:address).last_name.should eq user.last_name
    end
  end

  context "GET edit" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
    end

    it "should assigns @address" do
      get 'edit', :id => address.id
      assigns(:address).should eq(address)
    end
  end

  context "DELETE destroy" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
      #invoke address for create before any action
      address
    end

    it "should delete an address"do
      expect {
        delete :destroy, :id => address.id
      }.to change(Address, :count).by(-1)
    end

    it "should redirect to addresses" do
      delete :destroy, :id => address.id
      response.should redirect_to(checkout_addresses_path)
    end
  end

end
