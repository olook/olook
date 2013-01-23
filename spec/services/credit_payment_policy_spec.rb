require 'spec_helper'

describe CreditPaymentPolicy do
  
  context ".initialize" do
    it "should receive one parameter" do
      checker = CreditPaymentPolicy.new ([])
    end

    it "should throw exception for no parameters" do
      lambda {CreditPaymentPolicy.new}.should raise_error
    end
  end

  describe "#allow?" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    # Demeter's law ?!?!
    let(:master_variant) { cart.items.first.variant.product.master_variant }
    let(:coupon_policy) { CreditPaymentPolicy.new cart }

    before do
      master_variant.update_attributes(:price => 100, :retail_price => 0)
    end

    context "when cart has 1 item without any discount" do
      it "should allow credit payment" do
        coupon_policy.allow?.should be_true
      end
    end

    context "when cart has 1 item with olooklet discount" do
      it "should not allow credit payment" do

        master_variant.retail_price = 80
        master_variant.save

        coupon_policy = CreditPaymentPolicy.new cart
        coupon_policy.allow?.should be_false
      end
    end


    context "when cart has 2 items, but one is at full price" do
        
      let(:cart_with_2_items) { FactoryGirl.create(:cart_with_2_items) }        
      
      let(:cart_item_3) { FactoryGirl.create(:cart_item_3, :cart => cart_with_2_items) } 
      let(:master_variant) { cart_item_3.variant.product.master_variant } 
      
      let(:fullprice_cart_item) { FactoryGirl.create(:cart_item_2, :cart => cart_with_2_items) }        
      let(:fullprice_master_variant) { fullprice_cart_item.variant.product.master_variant }

      before do
        cart_with_2_items.items << fullprice_cart_item

        fullprice_master_variant.update_attributes(:price => 100, :retail_price => 0)
        master_variant.update_attributes(:price => 100, :retail_price => 80)
      end

      it "should have 2 items" do
        cart_with_2_items.should have(2).items
      end

      it "first item must be full price" do
        fullprice_master_variant.price.should == fullprice_master_variant.retail_price
      end

      it "second item must have discount" do
        master_variant.price.should > master_variant.retail_price
      end

      it "should allow credit payment" do
        coupon_policy = CreditPaymentPolicy.new cart_with_2_items
        coupon_policy.allow?.should be_true
      end
    end

    context "when there is a suggested product and a olooklet item" do

      let(:suggested_product) {FactoryGirl.create(:cart_item_2, :cart => cart)}

      before do
        cart.items << suggested_product
        Setting.stub(:checkout_suggested_product_id).and_return(suggested_product.product.id)
        
        master_variant.update_attributes(:price => 100, :retail_price => 80)
      end

      it "cart should have 2 items" do
        cart.should have(2).items
      end

      it "should not allow credit payment" do
        coupon_policy = CreditPaymentPolicy.new cart
        coupon_policy.allow?.should be_false
      end

    end
  end

end