# -*- encoding : utf-8 -*-
require "spec_helper"

describe SAC::AlertWorker do
  let(:alert) { double :alert }
  let(:mock_mail) { double :mail }

  it "should process a notification alert" do
    mock_mail.should_receive(:deliver)
    SACAlertMailer.should_receive(:send_notification).with(alert).and_return(mock_mail)  
    described_class.perform(alert)
  end
  
end