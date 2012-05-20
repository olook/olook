# -*- encoding : utf-8 -*-
describe AdminCreditService do

  let(:admin) {Factory :admin_superadministrator}
  subject {described_class.new(admin)}

    before(:each) do
      @user = Factory :user
    end


  it "should have a defined transaction limit defined on credit.yml config" do
    described_class::TRANSACTION_LIMIT.should be_an_instance_of(Float)
  end


  it "should allow operation if transaction limit has not exceeded" do
    subject.has_not_exceeded_transaction_limit?(described_class::TRANSACTION_LIMIT + 1).should be_false
  end

  context "when performing a credit operation" do
    
    it "should add credit to user account" do
      subject.add_credit(10, "Presente", @user)
      @user.credits.last.total.should == 10
    end

    it "should not add credit to user account if credit limit has been reached" do
      subject.add_credit(Credit::LIMIT_FOR_EACH_USER+1, "Presente", @user)
      @user.credits.should be_empty
    end

  end

  context "when performing a debit operation" do
    before(:each) do
      credit = FactoryGirl.create(:credit)
      @user.credits << credit
    end

    it "should remove credit from user account" do
      subject.remove_credit(@user.current_credit, "Erro do Operador", @user)
      @user.current_credit.should  == 0 
    end

    it "should not remove credit if value is higher than the user current credit" do
      subject.remove_credit(@user.current_credit+1, "Erro do Operador", @user)
      @user.current_credit.should == @user.current_credit
    end

  end


end