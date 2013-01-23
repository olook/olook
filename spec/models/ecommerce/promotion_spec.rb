require 'spec_helper'

describe Promotion do

  let!(:promo) { FactoryGirl.create(:first_time_buyers, starts_at: Date.today-1.day, ends_at: Date.today+1.day) }
  let(:cart) { FactoryGirl.create(:cart_with_items) }
  let(:user) { FactoryGirl.build(:user) }

  describe "#validations" do

    it { should have_many :rule_parameters }
    it { should have_many(:promotion_rules).through(:rule_parameters)}
    it { should have_one :action_parameter }
    it { should have_one(:promotion_action).through(:action_parameter)}
  end

  describe "#apply" do
    context "when promotion has action parameter with param" do
      it "returns true" do
        promo.apply(cart).should be_true
      end
    end
  end

  describe "#simulate" do
    context "when there's promotion to simulate" do
      it "returns true" do
        promo.simulate(cart)
        promo.promotion_action.should respond_to(:simulate).with(2).argument
      end
    end
  end

  describe ".best_promotion_for" do
    context "when there's promotion and cart to apply" do
      it "retuns best promotion" do
        described_class.select_promotion_for(cart).should eq(promo)
      end

      it "returns nil if coupon is better that promotion" do
        cart.should_receive(:total_coupon_discount).and_return(100.0)
        described_class.select_promotion_for(cart).should be_nil
      end
    end
  end

  describe "#should_apply_for?" do
    let!(:promotion_action) { mock_model(PercentageAdjustment) }
    let(:action_parameter) { mock_model(ActionParameter) }

    context "when cart has no coupon" do
      it "retuns true" do
        subject.should_apply_for?(cart).should be_true
      end
    end

    context "when cart has coupon" do

      it "returns true" do
        subject.should_receive(:is_greater_than_coupon?).and_return(true)
        cart.should_receive(:coupon).and_return(true)
        subject.should_apply_for?(cart).should be_true
      end

      it "returns false" do
        subject.should_receive(:is_greater_than_coupon?).and_return(false)
        cart.should_receive(:coupon).and_return(true)
        subject.should_apply_for?(cart).should be_false
      end
    end
  end
end
