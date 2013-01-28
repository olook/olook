# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MinorPriceAdjustment do
  # let!(:cart) { FactoryGirl.create(:cart_with_3_items) }
  

  describe "#simulate" do
    let(:cart) { FactoryGirl.create(:cart_with_one_item) }

    it { should respond_to(:simulate).with(2).arguments }

    context "when cart has items" do
      it "returns price of item with lower price" do
        subject.simulate(cart, 1).should eq(cart.items.first.price)
      end
    end    

    context "when cart has no items" do
      it "returns zero" do
        cart.items.should_receive(:any?).and_return(0)
        subject.simulate(cart, 1).should eq(0)
      end
    end

    context "cart with one item" do

      before do
        @cart_item = cart.items.first
        @cart_item.stub(:quantity => 1)
        @cart_item.stub(:price => BigDecimal("60"))
      end

      it "should create an adjustment of cart item value" do
        cart.stub(:items).and_return([@cart_item])
        subject.simulate(cart, 1).should eq BigDecimal("60")
      end

      context "cart with two items with different prices" do
        before do
          @minor_price_item = @cart_item.dup
          @minor_price_item.stub(:quantity => 1)
          @minor_price_item.stub(:price => BigDecimal("40"))
        end

        it { cart.should have(2).items }

        it "returns 40 (minor price item)" do
          cart.stub(:items).and_return([@cart_item, @minor_price_item])
          subject.simulate(cart, 1).should eq BigDecimal("40")
        end

        context "when quantity parameter is 2" do
          it "returns 100 (both item values)" do
            subject.simulate(cart, 2).should eq BigDecimal("100")
          end
        end

      end
    end  

  end

  describe "#apply" do
    it "set retail price as zero" do
      cart.items.first.cart_item_adjustment.should_receive(:update_attributes)
      subject.apply(cart, 1)
      cart.items.first.price.should eq(0)
    end

  end

end
