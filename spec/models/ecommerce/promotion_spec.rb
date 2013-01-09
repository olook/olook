require 'spec_helper'

describe Promotion do

  let(:promo) { FactoryGirl.create(:first_time_buyers) }
  describe "#validations" do


    it { should have_many :rules_parameters }
    it { should have_many(:promotion_rules).through(:rules_parameters)}

    it { should have_one :action_parameter }
    it { should have_one(:promotion_action).through(:action_parameter)}
  end

  describe "#apply" do
    let(:cart) { FactoryGirl.create(:cart_with_items) }
    let(:action_parameter) { FactoryGirl.build(:action_parameter) }

    context "returns true" do
      it "when promotion has no action parameter" do
        promo.apply(cart).should be_true
      end

      it "when promotion has action parameter with param" do
        promo.should_receive(:action_parameter).twice.and_return(action_parameter)
        promo.apply(cart).should be_true
      end
    end
  end
end