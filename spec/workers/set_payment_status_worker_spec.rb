# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SetPaymentStatusWorker do
  it "should not reprocess callback" do
    payment = (FactoryGirl.create(:moip_callback, :processed => true)).payment
    payment.should_not_receive(:set_state_moip)
    MoipCallback.any_instance.stub(:payment).and_return(payment)
    SetPaymentStatusWorker.perform
  end
  
  it "should set state for payment" do
    payment = (FactoryGirl.create(:moip_callback, :processed => false)).payment
    payment.should_receive(:set_state_moip)
    MoipCallback.any_instance.stub(:payment).and_return(payment)
    SetPaymentStatusWorker.perform
  end
  
  context "when no has payment associated" do
    it "should set error and remove from queue" do
      moip_callback = FactoryGirl.create(:clean_moip_callback, :processed => false)
      SetPaymentStatusWorker.perform
      moip_callback.reload.processed.should eq(true)
      moip_callback.error.should eq("Pagamento não identificado.")
    end
  end
end
