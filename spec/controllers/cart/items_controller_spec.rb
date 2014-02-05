# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Cart::ItemsController do 
	
	describe "POST #create", js: true do 		
		context "with valid variant params" do 
			let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
			let(:params) { {variant: { id: basic_bag.id }} }

	    it "finds a variant" do
	      post :create, params, :format => :js
	      assigns(:variant).should eq(basic_bag)
	    end

			it "adds an item to the cart instance" do
        post :create, params, :format => :js
        controller.send(:current_cart).items.first.variant.should eq(basic_bag)
      end

      it "renders create when item added and respond for js" do
        post :create, params, :format => :js
        response.should render_template ["create"]
      end
		end

		context "with invalid params" do  
      it "should render error in response for js" do
        post :create, :format=> :js
        response.should render_template ["error"]
      end
    end
	end  

	describe "DELETE #destroy", js: true do
		context "with valid params" do
			let(:cart) { FactoryGirl.create(:clean_cart) }
			let(:item) { FactoryGirl.build(:cart_item) }
			
			before(:each) do 
				Cart::ItemsController.any_instance.stub(:current_cart).and_return(cart) 
				cart.items << item
			end
			
			it "removes the cart item from the cart" do				
				Cart.first.items.count.should == 1
				expect {
					delete :destroy, { :id => item.id.to_s }, :format=> :js
				}.to change(Cart.first.items, :count).by(-1)
			end

			it "destroys the cart item itself" do
				CartItem.count.should == 1
				expect {
					delete :destroy, { :id => item.id.to_s }, :format=> :js
				}.to change(CartItem, :count).by(-1)
			end
		end

		context "with invalid params" do
      it "should render error in response for js" do
        delete :destroy, { :id => '' }, :format=> :js
        response.should render_template ["error"]
      end
    end
	end
end
