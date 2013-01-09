require 'spec_helper'

describe Promotion do

  let(:promo) { FactoryGirl.create(:first_time_buyers) }
  describe "#validations" do

    it { should have_many :rules_parameters }
    it { should have_many(:promotion_rules).through(:rules_parameters)}

    it { should have_one :action_parameter }
    it { should have_one(:promotion_action).through(:action_parameter)}
  end

  describe "#load_strategy" do
    it "should apply the appropriated strategy" do
      promo.load_strategy(nil, nil).class.should  eq(Promotions::PurchasesAmountStrategy)
    end
  end

  describe "#apply" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    it "returns true" do
      promo.apply(cart).should be_true
    end
  end
end
