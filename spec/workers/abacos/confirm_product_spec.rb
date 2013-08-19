# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmProduct do
  describe "#perform" do
    let(:fake_protocol) { 'PROT321' }

    it "should call process_product, process_inventory, process_price" do
      Abacos::ProductAPI.should_receive(:confirm_product).with(fake_protocol)
      REDIS.should_receive(:decrby).with("products_to_integrate", 1)
      described_class.perform fake_protocol
    end
  end
end
