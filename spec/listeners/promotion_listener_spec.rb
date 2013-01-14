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
end
