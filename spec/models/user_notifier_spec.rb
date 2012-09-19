# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserNotifier do

  describe ".get_carts" do
    it "should get the validators params to get orders" do
      validators = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      validators.should_not == []
    end

    it 'should not return carts without users' do
      FactoryGirl.create(:clean_cart)
      conditions = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      Cart.where(conditions.join(" AND ")).count.should == 0
    end
  end

  describe ".send_in_cart" do
    let(:user) { FactoryGirl.create :user }
    let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
    let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
    subject { FactoryGirl.create(:clean_cart, :user => user)}
    let(:mailer) { double(:mailer)}

    before do
      subject.add_item(basic_shoe_35)
      subject.update_attribute( "updated_at", Time.now - 24 * 60 * 60 )
      subject.save!
    end

    it "should send the order email" do
      validators = UserNotifier.get_carts( 0, 1, [ "notified = 0" ] )
      InCartMailer.should_receive(:send_in_cart_mail).with(subject, subject.items).and_return(mailer)
      mailer.should_receive(:deliver)
      UserNotifier.send_in_cart( validators.join(" AND ") )
    end
  end

  describe ".send_enabled_credits_notification" do
    let(:user) { FactoryGirl.create(:member) }
    # criar 2 users. Um com créditos disponíveis no começo desse mês e um com créditos disponíveis mês que vem.
    # Fazer o teste no mês atual, testar com DeLorean no mês seguinte e testar com DeLorean 3 meses para trás.
    it "should blablabla" do

    end
  end

  describe ".send_expiration_warning" do
    let(:user) { FactoryGirl.create(:member) }
    let(:other_user) { FactoryGirl.create(:member) }
    let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
    let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => user) }
    let(:other_user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => other_user) }
    # criar 2 users. Um com créditos que expiram no final desse mês e um com créditos que expiram no mês que vem.
    # Fazer o teste no mês atual, testar com DeLorean no mês seguinte e testar com DeLorean 3 meses para trás.
    context "on the 23rd" do
      it "should send the 23rd day warning to the user who has credits expiring in the end of the month" do
        other_user_credit.add({amount: 20})
        other_user_credit.credits.last.update_attribute('expires_at', DateTime.now + 1.year)

        user_credit.add({amount: 20})
        expiration_warning_date = (user_credit.credits.last.expires_at - 7.days)
        Delorean.time_travel_to(DateTime.new(expiration_warning_date.year, expiration_warning_date.month, 23))
        LoyaltyProgramMailer.should_receive(:send_expiration_warning).with(user,false).once
        LoyaltyProgramMailer.should_not_receive(:send_expiration_warning).with(other_user,false)

        UserNotifier.send_expiration_warning
        Delorean.back_to_the_present
      end
    end

    context "on the last day of the month" do
      it "should send the last day warning to the user who has credits expiring in the end of the month" do
        other_user_credit.add({amount: 20})
        other_user_credit.credits.last.update_attribute('expires_at', DateTime.now + 1.year)

        user_credit.add({amount: 20})
        expiration_warning_date = (user_credit.credits.last.expires_at - 1.days).end_of_month.beginning_of_day
        Delorean.time_travel_to(expiration_warning_date)
        LoyaltyProgramMailer.should_receive(:send_expiration_warning).with(user,true).once
        LoyaltyProgramMailer.should_not_receive(:send_expiration_warning).with(other_user,true)

        UserNotifier.send_expiration_warning true
        Delorean.back_to_the_present
      end
    end
  end

end
