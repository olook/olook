require 'spec_helper'

describe Promotion do

  describe "validations" do

    it { should have_many :rules_parameters }
    it { should have_many(:promotion_rules).through(:rules_parameters)}

    it { should have_one :action_parameter }
    it { should have_one(:promotion_action).through(:action_parameter)}
    # it { should have_many :promotion_actions }

  end

  describe "strategies" do
    it "should apply the appropriated strategy" do
      promo = FactoryGirl.create(:first_time_buyers)
      promo.load_strategy(nil, nil).class.should  eq(Promotions::PurchasesAmountStrategy)
    end
  end
end
