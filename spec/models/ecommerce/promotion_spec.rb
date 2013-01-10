require 'spec_helper'

describe Promotion do

  let(:promo) { FactoryGirl.create(:first_time_buyers) }
  let(:promo_action) { FactoryGirl.create(:percentage_adjustment) }
  describe "#validations" do


    it { should have_many :rule_parameters }
    it { should have_many(:promotion_rules).through(:rule_parameters)}

    it { should have_one :action_parameter }
    it { should have_one(:promotion_action).through(:action_parameter)}
  end

  describe "#apply" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    let(:action_parameter) { FactoryGirl.build(:action_parameter) }

    context "returns true" do
      it "when promotion has action parameter with param" do
        promo.should_receive(:promotion_action).and_return(promo_action)
        promo.should_receive(:action_parameter).and_return(action_parameter)
        promo.apply(cart).should be_true
      end

    end
  end
end
