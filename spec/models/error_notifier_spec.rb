# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ErrorNotifier do

  let(:payment) {FactoryGirl.build(:payment)}

  it "should call new relic tool" do
    NewRelic::Agent.should_receive(:add_custom_parameters).with({:error_msg => "braspag Request braspag error - Order Number  - Payment Expiration  - User ID "}).and_return(true)
    ErrorNotifier.send_notifier("braspag", Exception.new("braspag error"), payment).should be_nil
  end

  it "should call airbrake tool" do
    Airbrake.notify(error_class: "braspag Request", error_message: "braspag error")
    ErrorNotifier.send_notifier("braspag", Exception.new("braspag error"), payment).should be_nil
  end
end

