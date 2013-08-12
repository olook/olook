require 'spec_helper'

describe LoyaltyProgramCreditType do

  before :each do
    Delorean.back_to_the_present
    Credit.destroy_all
  end

  let(:user) { FactoryGirl.create(:member) }

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => loyalty_program_credit_type) }

  describe "credit operations" do
    let(:order) {FactoryGirl.create(:order, :user => user)}
    let(:amount) { BigDecimal.new("33.33") }
    let(:credits_attrs) {{:amount => amount, :order => order}}

    describe "adding credits" do
      context "when user creates a credit" do
        it "should add credits" do
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).total(DateTime.now + 1.month).should == amount
        end
      end
    end

    describe "removing credits" do
      
      context "when user hasn't enough credits" do
        it "should not remove" do
          user.user_credits_for(:loyalty_program).remove(credits_attrs).should be_false
          user.user_credits_for(:loyalty_program).total.should == 0.0
        end
      end

      context "when user has enough credits" do
        after do
          Delorean.back_to_the_present
        end

        it "should remove credits when credits is equal to debit" do
          Timecop.freeze(Time.local(2013, 9, 1, 12, 0, 0))

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)

          Timecop.freeze(Time.local(2013, 10, 1, 12, 0, 0))

          expect{
            user.user_credits_for(:loyalty_program).remove(credits_attrs)
          }.to change{ Credit.count }.by(1)
          
          user.user_credits_for(:loyalty_program).total(DateTime.now).should == 0.0

          Timecop.return
        end

        it "should remove credits when there's more than 1 credit" do
          3.times { user.user_credits_for(:loyalty_program).add(credits_attrs.dup) }

          Delorean.jump 1.month

          expect{
            user.user_credits_for(:loyalty_program).remove(credits_attrs.merge(:amount => BigDecimal.new("99")))
          }.to change{ Credit.count }.by(3)

          user.user_credits_for(:loyalty_program).total(DateTime.now).should == 0.99
        end

        it "should remove credits when credits is greater than debits" do
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          
          Delorean.jump 1.month

          expect{
            user.user_credits_for(:loyalty_program).remove(credits_attrs.merge(:amount => BigDecimal.new("31.33")))
          }.to change{ Credit.count }.by(1)
          
          user.user_credits_for(:loyalty_program).total(DateTime.now).should == 2.0
        end
      end

      context "when user hasn't got enough credits" do
        it "should not remove credits and should return false" do
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)

          Delorean.jump 1.month
          
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).remove(credits_attrs.dup.merge(:amount => amount*2)).should == false

          Delorean.back_to_the_present

          user.user_credits_for(:loyalty_program).remove(credits_attrs.dup).should == false
          user.user_credits_for(:loyalty_program).total(DateTime.now + 1.month).should == amount
        end
      end      
    end

    describe "credits to be expired" do

      after do
        Delorean.back_to_the_present
      end

      context "before they get activated" do
        it "should not have any credits to expire" do
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).add({amount: 52.3, order: order})
          LoyaltyProgramCreditType.credit_amount_to_expire(user.user_credits_for(:loyalty_program)).should == 0
        end
      end

      context "when they're active but not about to expire" do
        it "should not have any credits to expire" do
  
          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).add({amount: 52.3, order: order})

          Delorean.time_travel_to((DateTime.now + 1.month).beginning_of_month + 5.days)

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)        

          LoyaltyProgramCreditType.credit_amount_to_expire(user.user_credits_for(:loyalty_program)).should == 0
        end
      end

      context "when the first ones are about to expire" do
        it "should have the first two credits about to expire" do

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).add({amount: 52.3, order: order})

          Delorean.time_travel_to((DateTime.now + 1.month).beginning_of_month + 5.days)

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)        

          Delorean.time_travel_to((DateTime.now + 1.month).beginning_of_month + 20.days)          

          LoyaltyProgramCreditType.credit_amount_to_expire(user.user_credits_for(:loyalty_program)).should == amount + 52.3
        end
      end      

      context "when the third one is about to expire" do
        it "should have the third credit about to expire" do

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
          user.user_credits_for(:loyalty_program).add({amount: 52.3, order: order})

          Delorean.time_travel_to((DateTime.now + 1.month).beginning_of_month + 5.days)

          user.user_credits_for(:loyalty_program).add(credits_attrs.dup)        

          Delorean.time_travel_to((DateTime.now + 2.months).beginning_of_month + 20.days)

          LoyaltyProgramCreditType.credit_amount_to_expire(user.user_credits_for(:loyalty_program)).should == amount
        end
      end            

    end

  end
end
