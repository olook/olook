# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CartBuilder do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:gift_recipient) { FactoryGirl.create(:gift_recipient, :user => nil) }
  let(:gift_occasion) { FactoryGirl.create(:gift_occasion, :user => nil, :gift_recipient => gift_recipient) }
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
  let(:controller) { double(Users::RegistrationsController) }

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
    
    it "should redirect back when no has products in session" do
      flash = {}
      controller.stub(:session).and_return({})
      controller.stub(:flash).and_return(flash)
      controller.stub(:current_order)
      controller.stub(:current_user)
      CartBuilder.gift(controller).should be(:back)
      flash[:notice].should eq("Produtos não foram adicionados")
    end

    it "should redirect back when fail to get order" do
      flash = {}
      controller.stub(:session).and_return({:gift_products => mock})
      controller.stub(:flash).and_return(flash)
      controller.stub(:current_order)
      controller.stub(:current_user)
      CartBuilder.gift(controller).should be(:back)
      flash[:notice].should eq("Produtos não foram adicionados")
    end
    
    it "should set order to restricted" do
      order = FactoryGirl.create(:order)
      controller.stub(:session).and_return({:gift_products => mock})
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(order)
      controller.stub(:current_user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      
      order.restricted.should be_true
    end

    it "should destroy all line items" do
      order = line_items[0].order
      
      controller.stub(:session).and_return({:gift_products => mock})
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(order)
      controller.stub(:current_user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error

      order.line_items.count.should eq(0)
    end
    
    it "should set user in occasion session" do
      gift_occasion.user.should be_nil

      controller.stub(:session).and_return({
        :gift_products => mock,
        :occasion_id => gift_occasion.id
      })
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      gift_occasion.reload.user_id.should eq(user.id)
    end
    
    it "should set user in occasion recipient" do
      gift_recipient.user.should be_nil

      controller.stub(:session).and_return({
        :gift_products => mock,
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      gift_recipient.reload.user_id.should eq(user.id)
    end
    
    it "should add products to order" do
      controller.stub(:session).and_return({
        :gift_products => {
          "0" => variant_35,
          "1" => variant_37,
          "2" => variant_40,
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      
      restricted_order.line_items[0].variant_id.should eq(variant_35.id)
      restricted_order.line_items[1].variant_id.should eq(variant_37.id)
      restricted_order.line_items[2].variant_id.should eq(variant_40.id)
    end
    
    it "should execute calculate gift prices" do
      controller.stub(:session).and_return({
        :gift_products => {
          "0" => variant_35,
          "1" => variant_37,
          "2" => variant_40,
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)
      CartBuilder::GiftCartBuilder.should_receive(:calculate_gift_prices)
                                  .with(restricted_order)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
    end
    
    it "should clear gift products" do
      session = {
        :gift_products => {
          "0" => variant_35,
          "1" => variant_37,
          "2" => variant_40,
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      }
      controller.stub(:session).and_return(session)
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      
      session[:gift_products].should be_nil
    end
    
    it "should set success flash when add more than one product in cart" do
      flash = {}
      controller.stub(:session).and_return({
        :gift_products => {
          "0" => variant_35,
          "1" => variant_37,
          "2" => variant_40,
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return(flash)
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      
      flash[:notice].should eq("Produtos adicionados com sucesso")
    end
    
    it "should set error flash when no has products in cart" do
      flash = {}
      restricted_order.stub(:add_variant)
      controller.stub(:session).and_return({
        :gift_products => {
          "0" => variant_35
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return(flash)
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)

      expect {
        CartBuilder.gift(controller)
      }.to raise_error
      
      flash[:notice].should eq("Um ou mais produtos selecionados não estão disponíveis")
    end
    
    it "should return cart_path" do
      controller.stub(:session).and_return({
        :gift_products => {
          "0" => variant_35,
          "1" => variant_37,
          "2" => variant_40,
        },
        :occasion_id => gift_occasion.id,
        :recipient_id => gift_recipient.id
      })
      controller.stub(:flash).and_return({})
      controller.stub(:current_order).and_return(restricted_order)
      controller.stub(:current_user).and_return(user)
      path = mock
      controller.stub(:cart_path).and_return(path)

      CartBuilder.gift(controller).should be(path)
    end
    
  end

  context "build offline session" do
    it "should return cart_path" do
      path = mock
      controller.stub(:session).and_return({})
      controller.stub(:cart_path).and_return(path)
      CartBuilder.offline(controller).should be(path)
    end
    
    it "should add variant to order" do
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