# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserCredit do
  it { should belong_to(:user) }
  it { should belong_to(:credit_type) }
  it { should have_many(:credits) }

  describe "when basic methods are being tested" do
    let(:user) { FactoryGirl.create(:member) }
    let(:credit_type){ mock_model(CreditType, :total => 25.03, :add => true, :remove => true) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => credit_type) }
    
    it "should run the total method" do
      date_time = DateTime.now
      user_credit.credit_type.should_receive(:total).with(user_credit, date_time).and_return(25.03)
      user_credit.total(date_time).should eq(25.03)
    end

    it "should run the add method" do
      order = Order.new
      user_credit.credit_type.should_receive(:add).with(22.03,user_credit,order).and_return(true)
      user_credit.add(22.03,order).should eq(true)
    end

    it "should run the remove method" do
      order = Order.new
      user_credit.credit_type.should_receive(:remove).with(22.03,user_credit,order).and_return(true)
      user_credit.remove(22.03,order).should eq(true)
    end


  end

end
