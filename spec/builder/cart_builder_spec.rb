# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartBuilder do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:variant_35) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:variant_37) { FactoryGirl.create(:basic_shoe_size_37) }
  let(:variant_40) { FactoryGirl.create(:basic_shoe_size_40) }
  let(:restricted_order) { FactoryGirl.create(:restricted_order, :user => user) }
  let(:line_items) do
    [
      FactoryGirl.create(:line_item, :order => restricted_order, :variant => variant_35),
      FactoryGirl.create(:line_item, :order => restricted_order, :variant => variant_37),
      FactoryGirl.create(:line_item, :order => restricted_order, :variant => variant_40)
    ]
  end

  context "build gift product" do
    context "calculate gift prices" do
      it "should don't apply gift when order is not restricted" do
        restricted_order.restricted = false
        CartBuilder::GiftCartBuilder.calculate_gift_prices(restricted_order).should be_nil
      end

      it "should don't apply gift when order is empty" do
        CartBuilder::GiftCartBuilder.calculate_gift_prices(restricted_order).should be_nil
      end

      it "should apply gift price in lines items" do
        order = line_items[0].order
        
        line_items[0].variant.should_receive(:gift_price).with(0).and_return(10)
        line_items[1].variant.should_receive(:gift_price).with(1).and_return(20)
        line_items[2].variant.should_receive(:gift_price).with(2).and_return(30)

        order.stub(:line_items => line_items)
        
        expect {
          CartBuilder::GiftCartBuilder.calculate_gift_prices(order)
        }.to_not raise_error
        
        line_items[0].reload.retail_price.should eq(10)
        line_items[1].reload.retail_price.should eq(20)
        line_items[2].reload.retail_price.should eq(30)
      end
    end
    
    it "should redirect back when no has products in session"
    it "should redirect back when fail to get order"
    
    it "should set order to restricted"
    it "should destroy all line items"
    
    it "should set user in occasion session"
    it "should set user in occasion recipient"
    
    it "should add products to order"
    
    it "should execute calculate gift prices"
    
    it "should clear gift products"
    it "should set success flash when add more than one product in cart"
    it "should set error flash when no has products in cart"
    
    it "should return cart_path"
    
  end

  context "build offline session" do
    it "should return cart_path" do
      controller = double(Users::RegistrationsController)
      path = mock
      controller.stub(:session).and_return({})
      controller.stub(:cart_path).and_return(path)
      CartBuilder.offline(controller).should be(path)
    end
    
    it "should add variant to order" do
      controller = double(Users::RegistrationsController)

      hash_session = {:offline_variant => { "id" => variant_35.id } }
      
      controller.stub(:session).and_return(hash_session)
      controller.stub(:cart_path).and_return(nil)
      
      order = double(Order)
      order.should_receive(:add_variant).with(variant_35)
      
      controller.stub(:current_order).and_return(order)
      
      expect {
        CartBuilder.offline(controller)
      }.to_not raise_error
      
      hash_session[:offline_variant].should be_nil
    end
  end
end