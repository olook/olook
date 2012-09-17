# -*- encoding : utf-8 -*-
require "spec_helper"

describe CreditCard do

  let(:order) { FactoryGirl.create(:order) }
  subject { FactoryGirl.build(:credit_card, :order => order) }

  before :each do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
  end

  context "attributes validation" do
    it { should validate_presence_of(:bank) }
    it { should validate_presence_of(:user_name) }
    it { should validate_presence_of(:credit_card_number) }
    it { should validate_presence_of(:security_code) }
    it { should validate_presence_of(:expiration_date) }
    it { should validate_presence_of(:user_identification) }
    it { should validate_presence_of(:telephone) }
    it { should validate_presence_of(:user_birthday) }

    it { should allow_value("(11)1111-1111").for(:telephone) }
    it { should allow_value("(11)9111-1111").for(:telephone) }
    it { should allow_value("(11)91111-111").for(:telephone) }
    it { should allow_value("(11)91111-1111").for(:telephone) }
    it { should_not allow_value("(21)91111-111").for(:telephone) }
    it { should_not allow_value("(21)91111-1111").for(:telephone) }
    it { should_not allow_value("2222-2222").for(:telephone) }
    it { should_not allow_value("92222-2222").for(:telephone) }

    describe 'credit card number length' do
      context 'number too short' do
        it { should_not allow_value("1111").for(:credit_card_number) }
        it { should_not allow_value("1111111111111").for(:credit_card_number) }
      end
      context 'number too long' do
        it { should_not allow_value("111122223333444455").for(:credit_card_number) }
      end
      context 'regular numbers for Visa and Master' do
        it { should allow_value("1111222233334444").for(:credit_card_number) }
        it { should_not allow_value("1111 2222 3333 4444").for(:credit_card_number) }
      end
      context 'numbers for Amex and Diners' do
        it { should allow_value("11122223333444").for(:credit_card_number) }
        it { should_not allow_value("1111 2222 3333 444").for(:credit_card_number) }
      end
      context 'numbers for Hypercard' do
        it { should allow_value("11112222333344445").for(:credit_card_number) }
        it { should_not allow_value("1111 2222 3333 4444 5").for(:credit_card_number) }
      end
    end

    it { should allow_value("3456").for(:security_code) }
    it { should allow_value("345").for(:security_code) }
    it { should_not allow_value("34567").for(:security_code) }
    it { should_not allow_value("1bfj").for(:security_code) }

    it { should allow_value("12/06/1986").for(:user_birthday) }
    it { should_not allow_value("12/06/19").for(:user_birthday) }
    it { should_not allow_value("12/6/1990").for(:user_birthday) }

    it { should allow_value("12/06").for(:expiration_date) }
    it { should_not allow_value("1206").for(:expiration_date) }
    it { should_not allow_value("1/6").for(:expiration_date) }

  end

  context "expiration date" do
    it "should set payment expiration date after create" do
      CreditCard.any_instance.stub(:build_payment_expiration_date).and_return(expiration_date = CreditCard::EXPIRATION_IN_MINUTES.days.from_now)
      credit_card = FactoryGirl.create(:credit_card)
      credit_card.payment_expiration_date.should == expiration_date
    end
  end

  it "should return to_s version" do
    subject.to_s.should == "CartaoCredito"
  end

  it "should return human to_s human version" do
    subject.human_to_s.should == "Cartão de Crédito"
  end

  context "creating a credit_card" do
    it "should crypt the credt card number" do
      credit_card_number = "1234123412341234"
      credit_card = FactoryGirl.create(:credit_card, :credit_card_number => credit_card_number)
      credit_card.credit_card_number.should == "XXXXXXXXXXXX1234"
    end
  end

  context "installments" do
    it "should return 2 installments" do
      CreditCard.installments_number_for(89.89).should == 2
    end

    it "should return 1 installments" do
      CreditCard.installments_number_for(3.34).should == 1
    end

    it "should return 6 installments" do
      CreditCard.installments_number_for(500).should == CreditCard::PAYMENT_QUANTITY
    end
  end


  context "attributes validation" do
    it { should be_valid }

    describe "when is paid with credit card" do
      it "requires user_name" do
        subject.user_name = nil
        subject.valid?.should_not eq(true)
      end

      it "requires user_birthday" do
        subject.user_birthday = nil
        subject.valid?.should_not eq(true)
      end

      it "requires security_code" do
        subject.security_code = nil
        subject.valid?.should_not eq(true)
      end

      it "requires expiration_date" do
        subject.expiration_date = nil
        subject.valid?.should_not eq(true)
      end

      it "requires user_identification" do
        subject.user_identification = nil
        subject.valid?.should_not eq(true)
      end

      it "requires telephone" do
        subject.telephone = nil
        subject.valid?.should_not eq(true)
      end
    end
  end

  describe ".user_data" do
    let(:user) { FactoryGirl.create(:user, :birthday => Date.new(1983,12,21)) }

    it "returns a hash with user data used to fill in credit card" do
      data = { :user_name => user.name, :user_identification => user.cpf, :user_birthday => "21/12/1983" }
      CreditCard.user_data(user).should == data
    end
  end
end
