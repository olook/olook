# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::IntegrateProducts do
  describe "#perform" do
    it "should call process_product, process_inventory, process_price" do
      described_class.should_receive :process_products
      described_class.should_receive :process_prices
      Abacos::IntegrateProductsObserver.should_receive(:perform).and_return(true)

      described_class.perform
    end
  end

  describe "#process_products" do
    it 'should download product changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_products).and_return([:variant, :product])
      described_class.should_receive(:parse_product_class).with(:product).and_return(Abacos::Product)
      described_class.should_receive(:parse_product_class).with(:variant).and_return(Abacos::Variant)
      described_class.should_receive(:order_products).and_return([:product, :variant])

      Abacos::Product.should_receive(:parse_abacos_data).with(:product).and_return(:parsed_product)
      Abacos::Variant.should_receive(:parse_abacos_data).with(:variant).and_return(:parsed_variant)

      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Product", :parsed_product)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Variant", :parsed_variant)
      Abacos::IntegrateProductsObserver.should_receive(:products_to_be_integrated).with(2).and_return("2")
      described_class.process_products
    end
  end

  describe '.order_products' do
    let(:product) { { codigo_produto: '789' } }
    let(:variant) { { codigo_produto: '456', codigo_pai: '123' } }
    it "orders products before variants" do
      expect(described_class.order_products([variant, product, product, variant])).to eq([product, product, variant, variant])
    end
  end

  describe "#process_prices" do
    it 'should download price changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_prices).and_return([:product_price, :variant_price])
      described_class.should_receive(:parse_price_class).with(:product_price).and_return(Abacos::ProductPrice)
      described_class.should_receive(:parse_price_class).with(:variant_price).and_return(Abacos::VariantPrice)

      Abacos::ProductPrice.should_receive(:parse_abacos_data).with(:product_price).and_return(:parsed_product_price)
      Abacos::VariantPrice.should_receive(:parse_abacos_data).with(:variant_price).and_return(:parsed_variant_price)

      Resque.should_receive(:enqueue).with(Abacos::IntegratePrice, "Abacos::ProductPrice", :parsed_product_price)
      Resque.should_receive(:enqueue).with(Abacos::IntegratePrice, "Abacos::VariantPrice", :parsed_variant_price)

      described_class.process_prices
    end
  end

  describe "#parse_product_class" do
    let(:downloaded_product) { load_abacos_fixture :product }
    let(:downloaded_variant) { load_abacos_fixture :variant }

    it "should return Abacos::Product if the product is a parent" do
      described_class.send(:parse_product_class, downloaded_product).should be(Abacos::Product)
    end
    it "should return Abacos::Variant if the product isn't a parent" do
      described_class.send(:parse_product_class, downloaded_variant).should be(Abacos::Variant)
    end
  end

  describe "#parse_price_class" do
    let(:downloaded_product_price) { load_abacos_fixture :product_price }
    let(:downloaded_variant_price) { load_abacos_fixture :variant_price }

    it "should return Abacos::ProductPrice if the product is a parent" do
      described_class.send(:parse_price_class, downloaded_product_price).should be(Abacos::ProductPrice)
    end
    it "should return Abacos::VariantPrice if the product isn't a parent" do
      described_class.send(:parse_price_class, downloaded_variant_price).should be(Abacos::VariantPrice)
    end
  end
end
