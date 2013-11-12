require 'spec_helper'

describe CartItem do
  it { should belong_to(:cart) }
  it { should belong_to(:variant) }
  let(:cart_item) { FactoryGirl.create(:cart_item_that_belongs_to_a_cart) }

  describe "#product_quantity" do
    context "for default product" do
      it "should return 1" do
        cart_item.product_quantity.should == [1]
      end
    end

    context "for suggested product" do
      it "should return an array from 1 to 5" do
        cart_item.stub(:is_suggested_product?).and_return(true)
        cart_item.stub(:suggested_product_quantity).and_return([1,2,3,4,5])

        cart_item.product_quantity.should == [1,2,3,4,5]
      end
    end
  end

  describe "#price" do
    context "cart_item with adjustment" do
      it "returns price" do
        cart_item.product.stub(:price).and_return(BigDecimal("100.00"))
        cart_item.price.to_s.should eq("100.0")
      end
    end
  end

  describe "#retail_price" do
    let(:adjustment) { FactoryGirl.create(:cart_item_adjustment, cart_item: cart_item) }

    before do
      cart_item.update_attributes(:quantity => 1)
    end

    context "when cart has no coupon" do
      context "cart_item without adjustment" do
        it "returns full price" do
          cart_item.product.master_variant.update_attribute(:retail_price, "100.00")
          cart_item.retail_price.to_s.should eq("100.0")
        end
      end

      context "cart_item with adjustment" do
        it "returns value calculated" do
          cart_item.product.stub(:price).and_return(BigDecimal("59.99"))
          cart_item.product.stub(:retail_price).and_return(BigDecimal("0"))
          cart_item.stub(:adjustment_value).and_return(BigDecimal("9.99"))
          cart_item.retail_price.to_s.should eq("50.0")
        end
      end

      context "when cart has coupon" do
        let(:value_coupon) { FactoryGirl.build(:coupon)}
        let(:action_parameter) { FactoryGirl.build(:action_parameter, action_params: {param: 20}, promotion_action: PercentageAdjustment.create ) }
        let(:percentage_coupon) { FactoryGirl.build(:coupon, action_parameter: action_parameter) }

        it "returns full price for value coupon" do
          cart_item.product.stub(:price).and_return(BigDecimal("59.99"))
          cart_item.cart.stub(:coupon).and_return(value_coupon)
          cart_item.retail_price.should eq(cart_item.product.price)
        end

        it "returns price with percentage applied for percentage coupon" do
          cart_item.product.stub(:price).and_return(BigDecimal("100.00"))
          cart_item.cart.stub(:coupon).and_return(percentage_coupon)
          cart_item.update_attributes(:quantity => 1)
          cart_item.retail_price.to_f.should eq(80.0)
        end
      end
    end

    context " retail price for olooklet" do
      pending " TODO "
    end

    context " retail price for not olooklet" do
      pending " TODO "
    end

  end

  describe "#adjustment" do
    context "when cart_item has cart_item_adjustment" do
      it "returns value of cart item adjustment" do
        cart_item.adjustment_value.should eq(cart_item.cart_item_adjustment.value)
      end
    end

    context "when cart_item has no cart_item_adjustment" do
      it "creates new cart item adjustment" do
        cart_item.should_receive(:cart_item_adjustment).and_return(nil)
        cart_item.adjustment_value.should be_true
      end
    end
  end

  describe "#adjustment_value" do
    it {should respond_to :adjustment_value}
  end

  describe "#should_apply?" do
    context "when cart item has no liquidation" do
      it "returns true" do
        cart_item.should_apply?(BigDecimal("100")).should be_true
      end
    end

    context "when cart item has liquidation" do
      it "returns true if adjust is greater that liquidation discount" do
        cart_item.should_receive(:liquidation?).twice.and_return(true)
        cart_item.should_receive(:price).and_return(BigDecimal("100"))
        cart_item.should_receive(:retail_price).and_return(BigDecimal("95"))
        cart_item.should_apply?(BigDecimal("10")).should be_true
      end

      it "returns false if liquidation discount is greater that adjust" do
        cart_item.should_receive(:liquidation?).twice.and_return(true)
        cart_item.should_receive(:price).and_return(BigDecimal("100"))
        cart_item.should_receive(:retail_price).and_return(BigDecimal("80"))
        cart_item.should_apply?(BigDecimal("10")).should be_false
      end
    end
  end
end
