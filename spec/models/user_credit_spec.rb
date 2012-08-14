# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserCredit do
  let(:user) { FactoryGirl.create(:member) }
  let(:invite_credit_type) { FactoryGirl.create(:invite_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => invite_credit_type) }

  it { should belong_to(:user) }
  it { should belong_to(:credit_type) }
  it { should have_many(:credits) }
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "testing total" do
    context "when the user has no credits" do
      it "should show zero" do
        user_credit.total.should == 0.0
      end
    end
  end

  describe "adding and removing credits" do
    context "when user creates a credit" do
      let(:order) {FactoryGirl.create(:order, :user => user)}
      let(:amount) { BigDecimal.new("33.33") }
      it "should add credits" do
        user_credit.add(amount,order)
        user_credit.total.should == amount
      end

      it "should remove credits" do
        user_credit.add(amount,order)
        user_credit.remove(amount,order)

        user_credit.total.should == 0.0
      end
    end
  end

end
