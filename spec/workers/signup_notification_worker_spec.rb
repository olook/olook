# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SignupNotificationWorker do
  let(:member) { FactoryGirl.create(:member) }
  let(:mock_mail) { double :mail }

  it "should send the welcome e-mail given a member id" do
    mock_mail.should_receive(:deliver)
    MemberMailer.should_receive(:welcome_email).with(member).and_return(mock_mail)
    
    member.welcome_sent_at.should be_nil
    
    described_class.perform(member.id)
    
    member.reload
    member.welcome_sent_at.should_not be_nil
  end
  
  it 'should raise "The welcome message for member X was already sent" when receiving a member to whom we sent a member' do
    User.stub(:find).with(123).and_return( mock_model(User, :id => 123, :welcome_sent_at => Time.now) )
    expect {
      described_class.perform(123)
    }.to raise_error(RuntimeError, "The welcome message for member 123 was already sent")
  end
end
