require "spec_helper"

describe PromotionListener do
  describe ".update" do
    let(:cart) { FactoryGirl.build(:cart_with_items) }
    context "verifying if method exists" do
      it "returns true" do
        described_class.update(cart).should be_true
      end
    end
  end
end

