require "spec_helper"

describe PromotionListener do
  describe ".update" do
    let(:cart) { FactoryGirl.build(:cart_with_items) }
    context "verifying if method exists" do
      it "returns true" do
        described_class.should respond_to(:update).with(1).argument
      end
    end
  end
end