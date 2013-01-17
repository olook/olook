require 'spec_helper'

describe PromotionAction do
  describe "#is_greater_than_coupon?" do
    let(:coupon) { mock_model Coupon, value: BigDecimal("50") }
    let(:cart) { mock_model Cart }
    context "when action discount is greater than cupon value" do
      it "retuns true" do
        subject.should_receive(:total_discount_for).and_return(BigDecimal("100"))
        cart.should_receive(:coupon).and_return(coupon)
        subject.is_greater_than_coupon?(cart).should be_true
      end
    end

    context "when action discount is not greater than cupon value" do
      it "retuns true" do
        subject.should_receive(:total_discount_for).and_return(BigDecimal("10"))
        cart.should_receive(:coupon).and_return(coupon)
        subject.is_greater_than_coupon?(cart).should be_false
      end
    end
  end
end
