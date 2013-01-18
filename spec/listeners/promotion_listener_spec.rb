require "spec_helper"

describe PromotionListener do
  let(:cart) { FactoryGirl.build(:cart_with_items) }
  describe ".update" do
    context "verifying if method exists" do
      it "returns true" do
        described_class.should respond_to(:update).with(1).argument
      end
    end
  end

  describe ".reset_adjustments_for" do
    context "when cart has items" do
      it "should reset value of all items" do
        described_class.reset_adjustments_for(cart)
        cart.items.collect(&:cart_item_adjustment).collect(&:value).sum.should eq(0)
      end
    end

    context "when cart has no items" do
      it "returns true" do
        cart.should_receive(:items).and_return([])
        described_class.reset_adjustments_for(cart).should be_true
      end
    end
  end

  describe ".should_apply_coupon?" do
    let(:coupon) { mock_model(Coupon, value: 100)}
    let(:promotion) { mock_model(Promotion)}
    let(:cart) { mock_model Cart}
    
    context "when coupon value is greater than promotion discount value" do
      it "returns true" do
        Promotion.should_receive(:select_promotion_for).and_return(promotion)
        promotion.should_receive(:total_discount_for).and_return(50)
        described_class.should_apply_coupon?(cart,coupon).should be_true
      end
    end

    context "when coupon value is smaller than promotion discount value" do
      it "returns false" do
        Promotion.should_receive(:select_promotion_for).and_return(promotion)
        promotion.should_receive(:total_discount_for).and_return(150)
        described_class.should_apply_coupon?(cart,coupon).should be_false
      end
    end

    context "when there's no promotion for cart" do
      it "returns true" do
        Promotion.should_receive(:select_promotion_for).and_return(nil)
        described_class.should_apply_coupon?(cart,coupon).should be_true
      end
    end
  end
end
