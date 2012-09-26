# -*- encoding : utf-8 -*-
require "spec_helper"

describe SendExpirationTomorrowWarningWorker do
  let(:member) { FactoryGirl.create(:member) }
  let(:another_member) { FactoryGirl.create(:user) }
  let(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => member) }  
  let(:another_user_credit) { FactoryGirl.create(:user_credit, :credit_type => loyalty_program_credit_type, :user => another_member) }  
  let(:mock_mail) { double :mail }

  it "should send the send credit expiration warning to everyone" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})

    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    expiration_warning_date = (user_credit.credits.last.expires_at - 7.days)
    Delorean.time_travel_to(DateTime.new(expiration_warning_date.year, expiration_warning_date.month, 23))

  
    mock_mail.should_receive(:deliver).twice
    LoyaltyProgramMailer.should_receive(:send_expiration_warning).twice.and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end

  it "should send the send credit expiration warning to the first user only" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    
    Delorean.time_travel_to(DateTime.now + 1.month)
   
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    expiration_warning_date = (user_credit.credits.first.expires_at - 7.days)
    Delorean.time_travel_to(DateTime.new(expiration_warning_date.year, expiration_warning_date.month, 23))

  
    mock_mail.should_receive(:deliver).once
    LoyaltyProgramMailer.should_receive(:send_expiration_warning).once.and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end

  it "should send the send credit expiration warning to the last user only" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    
    Delorean.time_travel_to(DateTime.now + 1.month)
   
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    expiration_warning_date = (user_credit.credits.last.expires_at - 7.days)
    Delorean.time_travel_to(DateTime.new(expiration_warning_date.year, expiration_warning_date.month, 23))

  
    mock_mail.should_receive(:deliver).once
    LoyaltyProgramMailer.should_receive(:send_expiration_warning).once.and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end  

  it "should send the send credit expiration warning to noone (after)" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})

    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

    expiration_warning_date = (user_credit.credits.last.expires_at - 7.days)
    Delorean.time_travel_to(DateTime.now + 5.months)

  
    mock_mail.should_not_receive(:deliver)
    LoyaltyProgramMailer.should_not_receive(:send_expiration_warning).and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end


  it "should send the send credit expiration warning to noone (before)" do
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})
    user_credit.add({amount: 20})

    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})
    another_user_credit.add({amount: 20})

  
    mock_mail.should_not_receive(:deliver)
    LoyaltyProgramMailer.should_not_receive(:send_expiration_warning).and_return(mock_mail)

    described_class.perform    
    Delorean.back_to_the_present

  end

  
end
