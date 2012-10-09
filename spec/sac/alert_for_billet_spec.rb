# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AlertForBillet do
  
  let(:order) { mock_model(Order) }
  let(:payment) { mock_model(Payment) }
  let(:billet) { Billet.new }
  let(:order_with_billet) { mock_model(Order, :erp_payment => billet) }
  let(:today) { mock(:saturday? => false, :sunday? => false) }
  let(:time) { (Time.parse(Setting.sac_beginning_working_hour) + 1.hour) }
  let(:value) { BigDecimal.new(Setting.sac_purchase_amount_threshold.to_s) + 1 }

  it "should validate payment is billet" do
    order.stub(:erp_payment => payment)
    Order.stub(:find_by_number => order)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should validate is business days in saturday" do
    today = mock()
    today.should_receive(:saturday?).and_return(true)
    Date.should_receive(:today).and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should validate is business days in sunday" do
    today = mock()
    today.should_receive(:saturday?).and_return(false)
    today.should_receive(:sunday?).and_return(true)
    Date.should_receive(:today).twice.and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should validate is busines hours for less than beginning" do
    now =  (Time.parse(Setting.sac_beginning_working_hour) - 1.hour)
    Time.stub(:now => now)
    Date.stub_chain(:today).and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should validate is busines hours for greater than end" do
    now =  (Time.parse(Setting.sac_end_working_hour) + 1.hour)
    Time.stub(:now => now)
    Date.stub_chain(:today).and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should validate purchase amount is greater than minimium" do
    minimum_value = (BigDecimal.new(Setting.sac_purchase_amount_threshold.to_s) - 5)
    order_with_billet.should_receive(:amount_paid).and_return(minimum_value)
    Time.stub(:now => time)
    Date.stub_chain(:today).and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    SACAlertMailer.should_not_receive(:billet_notification)
    described_class.perform("XPTO")
  end
  
  it "should send mail" do
    order_with_billet.stub(:amount_paid).and_return(value)
    Time.stub(:now => time)
    Date.stub_chain(:today).and_return(today)
    Order.stub(:find_by_number => order_with_billet)
    alert_mailer = double(SACAlertMailer)
    alert_mailer.should_receive(:deliver!).and_return(true)
    SACAlertMailer.should_receive(:billet_notification)
                  .with(order_with_billet, Setting.sac_billet_subscribers)
                  .and_return(alert_mailer)
    described_class.perform("XPTO").should be(true)
  end

end
