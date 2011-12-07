# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmInventory do
  describe "#perform" do
    let(:fake_protocol) { 'PROT-INV-321' }
    it "should call confirm_inventory on ProductAPI" do
      Abacos::ProductAPI.should_receive(:confirm_inventory).with(fake_protocol)
      described_class.perform fake_protocol
    end
  end
end
