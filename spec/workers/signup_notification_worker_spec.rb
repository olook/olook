# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SignupNotificationWorker do
  let(:member) { FactoryGirl.create(:member) }
  let(:mock_mail) { double :mail }

  context "Common user" do
    it "should send the welcome e-mail given a member id" do
      mock_mail.should_receive(:deliver)
      MemberMailer.should_receive(:welcome_email).with(member).and_return(mock_mail)
      expect(member.welcome_sent_at).to be_nil
      described_class.perform(member.id)
      member.reload
      expect(member.welcome_sent_at).to_not be_nil
    end
  end

  context "Reseller" do
    let (:reseller) {FactoryGirl.create(:member, reseller: true)}
    it "should send the welcome e-mail given a member id" do
      mock_mail.should_receive(:deliver)
      MemberMailer.should_receive(:reseller_welcome_email).with(reseller).and_return(mock_mail)

      expect(reseller.welcome_sent_at).to be_nil

      described_class.perform(reseller.id)

      reseller.reload
      expect(reseller.welcome_sent_at).to_not be_nil
    end
  end

  describe "gift" do
    let (:male_half_user) { FactoryGirl.create(:member, :id => 1, :half_user => true, :gender => User::Gender[:male], :registered_via => User::RegisteredVia[:gift]) }
    let (:female_half_user) { FactoryGirl.create(:member, :id => 3, :half_user => true, :gender => User::Gender[:female], :registered_via => User::RegisteredVia[:gift]) }

    it "should send a welcome e-mail if gift male half user" do
      MemberMailer.should_receive(:welcome_gift_half_male_user_email).with(male_half_user).and_return(mock_mail)
      mock_mail.should_receive(:deliver)
      male_half_user.welcome_sent_at.should be_nil
      described_class.perform(male_half_user.id)
      male_half_user.reload
      male_half_user.welcome_sent_at.should_not be_nil
    end

    it "should send a welcome e-mail if gift female half user" do
      MemberMailer.should_receive(:welcome_gift_half_female_user_email).with(female_half_user).and_return(mock_mail)
      mock_mail.should_receive(:deliver)
      female_half_user.welcome_sent_at.should be_nil
      described_class.perform(female_half_user.id)
      female_half_user.reload
      female_half_user.welcome_sent_at.should_not be_nil
    end
  end

  describe "thin" do
    let (:male_half_user) { FactoryGirl.create(:member, :id => 1, :half_user => true, :gender => User::Gender[:male], :registered_via => User::RegisteredVia[:thin]) }
    let (:female_half_user) { FactoryGirl.create(:member, :id => 3, :half_user => true, :gender => User::Gender[:female], :registered_via => User::RegisteredVia[:thin]) }

    it "should send a welcome e-mail if thin male half user" do
      MemberMailer.should_receive(:welcome_thin_half_male_user_email).with(male_half_user).and_return(mock_mail)
      mock_mail.should_receive(:deliver)
      male_half_user.welcome_sent_at.should be_nil
      described_class.perform(male_half_user.id)
      male_half_user.reload
      male_half_user.welcome_sent_at.should_not be_nil
    end

    it "should send a welcome e-mail if thin female half user" do
      MemberMailer.should_receive(:welcome_thin_half_female_user_email).with(female_half_user).and_return(mock_mail)
      mock_mail.should_receive(:deliver)
      female_half_user.welcome_sent_at.should be_nil
      described_class.perform(female_half_user.id)
      female_half_user.reload
      female_half_user.welcome_sent_at.should_not be_nil
    end
  end

  it 'should raise "The welcome message for member X was already sent" when receiving a member to whom we sent a member' do
    User.stub(:find).with(123).and_return( mock_model(User, :id => 123, :welcome_sent_at => Time.now) )
    expect {
      described_class.perform(123)
    }.to raise_error(RuntimeError, "The welcome message for member 123 was already sent")
  end
end
