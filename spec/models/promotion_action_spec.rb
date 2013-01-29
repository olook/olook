require 'spec_helper'

describe PromotionAction do

  describe "#apply" do
    it { should respond_to(:apply).with(2).arguments }
  end

  describe "#simulate" do
    let(:cart) { mock_model Cart, items: [] }

    context "when cart has no items" do
      it "returns zero" do
        cart.items.should_receive(:any?).and_return(false)
        subject.simulate(cart, 0).should eq(0)
      end
    end
  end
end
