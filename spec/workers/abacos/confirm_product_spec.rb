# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmProduct do
  describe "#perform" do
    let(:fake_protocol) { 'PROT321' }

    it "should call process_product, process_inventory, process_price" do
      Abacos::ProductAPI.should_receive(:confirm_product).with(fake_protocol)
      described_class.perform fake_protocol
    end

    context "products to be integrated count" do
      before do
        Abacos::ProductAPI.should_receive(:confirm_product).with(fake_protocol)
      end
      it "decrements products to be integrated count" do
        Abacos::IntegrateProductsObserver.should_receive(:decrement!)
        described_class.perform fake_protocol
      end
    end
  end
end
