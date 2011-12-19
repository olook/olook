# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmPrice do
  describe "#perform" do
    let(:fake_protocol) { 'PROT-PRICE-321' }
    it "should call confirm_price on ProductAPI" do
      Abacos::ProductAPI.should_receive(:confirm_price).with(fake_protocol)
      described_class.perform fake_protocol
    end
  end
end
