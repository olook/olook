# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AlertForFraud do
  
  let(:order) { mock_model(Order) }
  let(:percent) { BigDecimal.new(Setting.sac_total_discount_threshold_percent.to_s) + 5 }
 
  it "should validate discount percentage is less than minimium" do
    total_percent = (BigDecimal.new(Setting.sac_total_discount_threshold_percent.to_s) - 5)
    order.stub_chain(:payments, :with_discount, :sum).and_return(total_percent)
    Order.stub(:find_by_number => order)
    SACAlertMailer.should_not_receive(:fraud_analysis_notification)
    described_class.perform("XPTO")
  end
  
  it "should send mail" do
    order.stub_chain(:payments, :with_discount, :sum).and_return(percent)
    Order.stub(:find_by_number => order)
    alert_mailer = double(SACAlertMailer)
    alert_mailer.should_receive(:deliver!).and_return(true)
    SACAlertMailer.should_receive(:fraud_analysis_notification)
                  .with(order, Setting.sac_fraud_subscribers)
                  .and_return(alert_mailer)
    described_class.perform("XPTO").should be(true)
  end

end
