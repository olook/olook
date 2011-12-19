# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmOrderStatus do
  describe "#perform" do
    let(:fake_protocol) { 'STAT-121' }
    it "should call confirm_order_status on OrderAPI" do
      Abacos::OrderAPI.should_receive(:confirm_order_status).with(fake_protocol)
      described_class.perform fake_protocol
    end
  end
end
