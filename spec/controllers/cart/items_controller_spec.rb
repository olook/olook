# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do 
	
	describe "#create", js: true do 		
		context "with valid variant params" do 
			let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
			let(:params) { {variant: { id: basic_bag.id }} }

	    it "finds a variant" do
	      post :create, params, :format => :js
	      assigns(:variant).should eq(basic_bag)
	    end

			it "adds an item to the cart instance" do
        post :create, params, :format => :js
        controller.current_cart.items.first.variant.should eq(basic_bag)
      end

      it "renders create when item added and respond for js" do
        post :create, params, :format => :js
        response.should render_template ["create"]
      end
		end
	end
end