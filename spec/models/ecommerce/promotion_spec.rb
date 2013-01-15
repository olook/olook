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

  describe ".matched_promotions_for" do
    context "when there's active promotion" do
      it "returns first buy promotion" do
        described_class.matched_promotions_for(cart).should eq([promo])
      end
    end
    context "when there's no active promotion" do
      it "returns an empty array" do
        described_class.should_receive(:active_and_not_expired).twice.and_return([])
        described_class.matched_promotions_for(cart).should eq([])
      end
    end
  end

  describe ".best_promotion_for" do
    context "when there's promotion and cart to apply" do
      it "retuns best promotion" do
        described_class.best_promotion_for(cart, [promo]).should eq(promo)
      end

      it "returns nil if coupon is better that promotion" do
        cart.should_receive(:total_coupon_discount).and_return(100.0)
        described_class.best_promotion_for(cart, [promo]).should be_nil
      end
    end
  end
end
