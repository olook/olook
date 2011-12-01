# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::IntegrateProducts do
  describe "#perform" do
    it "should call process_product, process_inventory, process_price" do
      described_class.should_receive :process_products
      described_class.should_receive :process_inventory
      described_class.should_receive :process_prices
      
      described_class.perform
    end
  end

  describe "#process_products" do
    it 'should download product changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_products).and_return([:product, :variant])
      described_class.should_receive(:parse_class).with(:product).and_return(Abacos::Product)
      described_class.should_receive(:parse_class).with(:variant).and_return(Abacos::Variant)
      
      Abacos::Product.should_receive(:parse_abacos_data).with(:product).and_return(:parsed_product)
      Abacos::Variant.should_receive(:parse_abacos_data).with(:variant).and_return(:parsed_variant)
      
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Product", :parsed_product)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Variant", :parsed_variant)

      described_class.process_products
    end
  end

  describe "#process_inventory" do
    it 'should download inventory changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_inventory).and_return([:inventory])
      Abacos::Inventory.should_receive(:parse_abacos_data).with(:inventory).and_return(:parsed_inventory)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Inventory", :parsed_inventory)
      described_class.process_inventory
    end
  end
  
  describe "#process_prices" do
    it 'should download price changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_prices).and_return([:price])
      Abacos::Price.should_receive(:parse_abacos_data).with(:price).and_return(:parsed_price)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Price", :parsed_price)
      described_class.process_prices
    end
  end
  
  describe "#parse_class" do
    let(:downloaded_product) { load_abacos_fixture :product }
    let(:downloaded_variant) { load_abacos_fixture :variant }

    it "should return Abacos::Product if the product is a parent" do
      described_class.send(:parse_class, downloaded_product).should be(Abacos::Product)
    end
    it "should return Abacos::Variant if the product isn't a parent" do
      described_class.send(:parse_class, downloaded_variant).should be(Abacos::Variant)
    end
  end
end
