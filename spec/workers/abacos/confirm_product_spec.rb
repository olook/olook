# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ConfirmProduct do
  describe "#perform" do
    let(:fake_protocol) { 'PROT321' }
    let(:fake_product_number) { '42' }
    context "process product" do
      before do
        Abacos::IntegrateProductsObserver.stub(:mark_product_integrated_as_success!).and_return("1")
      end

      it "calls process_product, process_inventory, process_price" do
        Abacos::ProductAPI.should_receive(:confirm_product).with(fake_protocol)
        described_class.perform(fake_protocol, fake_product_number)
      end
    end

    context "products to be integrated count" do
      before do
        Abacos::ProductAPI.should_receive(:confirm_product).with(fake_protocol)
      end
      it "decrements products to be integrated count as success" do
        Abacos::IntegrateProductsObserver.should_receive(:mark_product_integrated_as_success!)
        described_class.perform(fake_protocol, fake_product_number)
      end
    end

    context "error" do
      before do
        Abacos::ProductAPI.stub(:confirm_product).and_raise("Any error")
      end
      it "decrements products to be integrated count as failure" do
        Abacos::IntegrateProductsObserver.should_receive(:mark_product_integrated_as_failure!).with(fake_product_number, "Any error")
        described_class.perform(fake_protocol, fake_product_number)
      end
    end
  end
end
