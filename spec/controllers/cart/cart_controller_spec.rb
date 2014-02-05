# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::CartController do
  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:user) { FactoryGirl.create(:user) }
  let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }

  before :each do
    session[:cart_id] = cart.id
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  after :each do
    session[:cart_id] = nil
    session[:cart_coupon] = nil
  end

  context "when show" do
    it "should render show view" do
      ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i} 
      Product.stub(:find).with(ids).and_return([])
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

    context "when excluding coupon" do

      let(:params) { {cart: {coupon_code: ''}, format: :js} }

      it "is success" do
        put :update, params
        response.should be_success
      end

      it "should render error template" do
        Cart.any_instance.should_receive(:update_attributes).with({"coupon_code" => ''}).and_return(true)
        put :update, params
        response.should render_template ["update"]
      end
    end

    context "when adding a coupon" do
      let(:coupon) { FactoryGirl.create(:standard_coupon)}
      let(:params) { {cart: {coupon_code: coupon.code}, format: :js} }

      context "that applies" do

        before(:each) do
          Coupon.should_receive(:find_by_code).at_least(2).times.with( coupon.code ).and_return coupon
        end

        it "is a success" do
          put :update, params
          response.should be_success
        end

        it "associates a coupon to the cart" do
          put :update, params
          cart.reload.coupon.code.should eq(coupon.code)
        end

        it "should render template update" do
          put :update, params
          response.should render_template ["update"]
        end
      end

      context "that doesn't apply" do
        before(:each) do
          Cart.any_instance.stub(:total_promotion_discount).and_return(100)
          Cart.any_instance.stub(:total_liquidation_discount).and_return(100)
        end

        context "when sum of sale and promotion is greater than coupon value" do
          it "is a success" do
            put :update, params
            response.should be_success
          end

          it "should render template update" do
            put :update, params
            response.should render_template ["update"]
          end
        end

        context "when update gift wrap" do
          before(:each) do
            params[:cart].merge!({gift_wrap: "true"})
          end

          it "should update cart" do
            put :update, params
            cart.reload.gift_wrap.should eq(true)
          end

          it "should render template update" do
            put :update, params
            response.should render_template ["update"]
          end
        end
      end
    end
  end
end

