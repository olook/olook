# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do 

	let!(:cart) { FactoryGirl.create(:clean_cart) }
	
	before do  
		session[:cart_id] = cart.id
		controller.stub!(:current_referer)
		# binding.pry
	end
	
	describe "#create" do 		

		context "with valid variant params" do 
			let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
			let(:params) { {variant: { id: basic_bag.id }} }

			it "loads the cart from the session" do
				post :create, params, :format=> :js
				assigns(:cart).should eq(cart)
			end

	    it "finds a variant" do
	      post :create, params, :format=> :js
	      assigns(:variant).should eq(basic_bag)
	    end

			it "adds an item to the cart instance" do
        post :create, params, :format=> :js
        cart.items.first.variant.should eq(basic_bag)
      end

      it "renders create when item added and respond for js" do
        request.env['HTTP_ACCEPT'] = "text/javascript"
        post :create, params, :format=> :js
        response.should render_template ["create"]
      end
		end
	end
end