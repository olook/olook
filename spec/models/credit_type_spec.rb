require 'spec_helper'

describe CreditType do
  it { should have_many(:user_credits) }

  let(:user) { FactoryGirl.create(:member) }

  let(:credit_type) { FactoryGirl.create(:credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => credit_type) }
  

  describe "testing total" do
    context "when the user has some credit" do
      it "should show that the user has some credits" do
        FactoryGirl.create(:credit, :user => user, :user_credit => user_credit, :value => 4.00, :is_debit => 0)
        FactoryGirl.create(:credit, :user => user, :user_credit => user_credit, :value => 2.00, :is_debit => 1)
        credit_type.total(user_credit, DateTime.now).should eq(2.00)
      end
    end
    context "when the user has no credits" do
      it "should show that the user hasn't got any credits" do
        FactoryGirl.create(:credit, :user => user, :user_credit => user_credit, :value => 4.00, :is_debit => 0)
        FactoryGirl.create(:credit, :user => user, :user_credit => user_credit, :value => 4.00, :is_debit => 1)
        credit_type.total(user_credit, DateTime.now).should eq(0.00)
      end
    end

  end  
end
