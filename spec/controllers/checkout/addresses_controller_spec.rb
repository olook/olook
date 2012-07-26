# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::AddressesController do

  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:attributes) { {:state => 'MG', :street => 'Rua Jonas', :number => 123, :city => 'São Paulo', :zip_code => '37876-197', :neighborhood => 'Çentro', :telephone => '(35)3453-9848' } }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_without_items) { FactoryGirl.create(:clean_cart, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:coupon_expired) do
    coupon = double(Coupon)
    coupon.stub(:expired?).and_return(true)
    coupon.stub(:available?).and_return(false)
    coupon
  end
  let(:coupon_not_more_available) do
    coupon = double(Coupon)
    coupon.stub(:expired?).and_return(false)
    coupon.stub(:available?).and_return(false)
    coupon
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  after :each do
    session[:cart_id] = nil
    session[:gift_wrap] = nil
    session[:session_coupon] = nil
    session[:credits] = nil
    session[:freight] = nil
  end

  # before_filter :authenticate_user!
  # before_filter :check_order
  # before_filter :erase_freight

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

    it "should remove coupon from session when coupon is expired" do
      session[:cart_id] = cart.id
      session[:session_coupon] = coupon_expired
      get :index
      session[:session_coupon].should be_nil
    end

    it "should redirect to cart_path when coupon is expired" do
      session[:cart_id] = cart.id
      session[:session_coupon] = coupon_expired
      get :index
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Cupom expirado. Informe outro por favor")
    end
        
    it "should remove coupon from session when coupon is not more avialbe" do
      session[:cart_id] = cart.id
      session[:session_coupon] = coupon_not_more_available
      get :index
      session[:session_coupon].should be_nil
    end
    
    it "should redirect to cart_path when coupon is not more availabe" do
      session[:cart_id] = cart.id
      session[:session_coupon] = coupon_not_more_available
      get :index
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Cupom expirado. Informe outro por favor")
    end
    
    it "should remove credits from session when user not has more credit" do
      session[:cart_id] = cart.id
      session[:credits] = 1000
      get :index
      session[:credits].should be_nil
    end

    it "should redirect to cart_path when user not has more credit" do
      session[:cart_id] = cart.id
      session[:credits] = 1000
      get :index
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Você não tem créditos suficientes")
    end
  end

  it "should erase freight when call any action" do
    sign_in user
    session[:cart_id] = cart.id
    session[:freight] = mock
    get :index
    assigns(:cart).freight.should be_nil
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
      response.should redirect_to(new_cart_checkout_address_path)
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

  pending "POST create" do
    context "with valid a address" do
      before :each do
        freight = {:price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id}
        FreightCalculator.stub(:freight_for_zip).and_return(freight)
      end

      it "should create a address" do
        expect {
          post :create, :address => attributes
        }.to change(Address, :count).by(1)
      end

      it "should assign @cart" do
        # CartPresenter.should_receive(:new).with(Order.find(order))
        post :create, :address => attributes
      end

      context "when the user already have a cpf" do
        it "should redirect to new_credit_card_path" do
          post :create, :address => attributes
          response.should redirect_to(new_credit_card_path)
        end
      end

      context "when the user dont have a cpf" do
        it "should redirect to payments_path" do
          user.update_attributes(:cpf => nil)
          post :create, :address => attributes
          response.should redirect_to(payments_path)
        end
      end

      context "when the order already have a freight" do
        it "should update the freight" do
          expect {
            post :create, :address => attributes
          }.to change(Freight, :count).by(0)
        end
      end

      context "when the order dont have a freight" do
        it "should create a feight" do
          Order.find(order).freight.destroy
          expect{
            post :create, :address => attributes
          }.to change(Freight, :count).by(1)
        end
      end
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

  pending "PUT update" do
    it "should updates an address" do
      updated_attr = { :street => 'Rua Jones' }
      put :update, :id => @address.id, :address => updated_attr
      Address.find(@address.id).street.should eql('Rua Jones')
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

    it "should remove freight form session" do
      session[:freight] = mock
      delete :destroy, :id => address.id
      session[:freight].should be_nil
    end
    
    it "should redirect to addresses" do
      delete :destroy, :id => address.id
      response.should redirect_to(cart_checkout_addresses_path)
    end
  end

  pending "GET get_price_by_zipcode" do
    let(:freight){{:price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => 10, :total => 372.14, :coupon_discount => 0, :coupon_percentage => '' }}

    before :each do
        FreightCalculator.stub(:freight_for_zip).and_return(freight)
    end

    it 'should return a preview value based on the order value' do
      get :get_price_by_zipcode , :zipcode => '12345789'
      response.body.should == freight.to_json
    end
  end

  pending "POST assign_address" do
    context "with a valid address" do
      before :each do
        freight = {:price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id}
        FreightCalculator.stub(:freight_for_zip).and_return(freight)
      end

      context "when the order already have a freight" do
        it "should update the freight" do
          expect {
            post :assign_address, :delivery_address_id => @address.id
          }.to change(Freight, :count).by(0)
        end
      end

      context "when the order dont have a freight" do
        it "should create a feight" do
          Order.find(order).freight.destroy
          expect{
            post :assign_address, :delivery_address_id => @address.id
          }.to change(Freight, :count).by(1)
        end
      end

      context "when the user already have a cpf" do
        it "should redirect to new_credit_card_path" do
          post :create, :address => attributes
          response.should redirect_to(new_credit_card_path)
        end
      end

      context "when the user dont have a cpf" do
        it "should redirect to payments_path" do
          user.update_attributes(:cpf => nil)
          post :create, :address => attributes
          response.should redirect_to(payments_path)
        end
      end
    end

    context "without a valid address" do
      it "should redirect to address_path" do
        fake_address_id = "99999"
        post :assign_address, :delivery_address_id => fake_address_id
        response.should redirect_to(addresses_path)
      end
    end
  end
end
