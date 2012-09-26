# -*- encoding : utf-8 -*-
require "spec_helper"

describe SendEnabledCreditsNotificationWorker do
  let(:member) { FactoryGirl.create(:member) }
  let(:another_member) { FactoryGirl.create(:user) }
  let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }  
  let(:another_user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => another_member) }  
  let(:mock_mail) { double :mail }

  it "should send the send enabled credits notification to everyone" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})

    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    Delorean.time_travel_to(user_credit.credits.last.activates_at)

  
    mock_mail.should_receive(:deliver).twice
    LoyaltyProgramMailer.should_receive(:send_enabled_credits_notification).twice.and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end

  it "should send the send enabled credits notification to the first user only" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    
    Delorean.time_travel_to(DateTime.now + 1.month)
   
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    Delorean.time_travel_to(user_credit.credits.last.activates_at)

  
    mock_mail.should_receive(:deliver).once
    LoyaltyProgramMailer.should_receive(:send_enabled_credits_notification).once.and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end

  it "should send the send enabled credits notification to noone" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})

    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    Delorean.time_travel_to(DateTime.now + 5.months)

  
    mock_mail.should_not_receive(:deliver)
    LoyaltyProgramMailer.should_not_receive(:send_enabled_credits_notification).and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end


  
end
