# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do 
	let(:cart) { Cart.create }

	before(:each) do
		request.session[:cart_id] = cart.id
		controller.stub!(:current_referer)
		Cart.should_receive(:find).with(cart.id).and_return cart
	end

	describe "#create" do
		let(:params) { { variant: { id: '1' } } }

		it "loads the cart from the session" do
			post :create, params
			assigns(:cart).should eq(cart)
		end

		it "creates a cart item from params given" do
			cart.items.should_receive(:create).with(params)
			cart.items.first.should be_a(CartItem)
			cart.items.first.variant_id.should == 1
			post :create, params
		end
	end
end