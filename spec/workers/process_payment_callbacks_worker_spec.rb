# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProcessPaymentCallbacksWorker do
  it "should not reprocess callback" do
    payment = (FactoryGirl.create(:moip_callback, :processed => true)).payment
    payment.should_not_receive(:set_state_moip)
    MoipCallback.any_instance.stub(:payment).and_return(payment)
    ProcessPaymentCallbacksWorker.perform
  end

  it "should set state for payment" do
    moip_callback = (FactoryGirl.create(:moip_callback, :processed => false))
    payment = moip_callback.payment
    Payment.stub(:find_by_identification_code).and_return payment
    MoipCallback.any_instance.should_receive(:update_payment_status).with(payment)
    ProcessPaymentCallbacksWorker.perform
  end

  context "when no has payment associated" do
    it "should set error and remove from queue" do
      moip_callback = FactoryGirl.create(:clean_moip_callback, :processed => false)
      ProcessPaymentCallbacksWorker.perform
      moip_callback.reload.processed.should eq(true)
      moip_callback.error.should eq("Pagamento não identificado.")
    end
  end
end
