# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::IntegrateProducts do
  describe "#perform" do
    it 'should call integrate on all products and variants' do
      mock_integrate_product = double :product
      mock_integrate_product.should_receive :integrate

      mock_integrate_variant = double :variant
      mock_integrate_variant.should_receive :integrate
      
      Abacos::DownloadProducts.should_receive(:download_products).and_return([:product, :variant])
      described_class.should_receive(:parse_abacos_product).with(:product).and_return(mock_integrate_product)
      described_class.should_receive(:parse_abacos_product).with(:variant).and_return(mock_integrate_variant)

      described_class.perform
    end
  end
  
  describe "#parse_abacos_product" do
    let(:downloaded_product) { load_abacos_fixture :product }
    let(:downloaded_variant) { load_abacos_fixture :variant }

    it "should create a Product if the product is a parent" do
      result = described_class.send :parse_abacos_product, downloaded_product
      result.should be_a Abacos::Product
    end
    it "should create a Variant if the product isn't a parent" do
      result = described_class.send :parse_abacos_product, downloaded_variant
      result.should be_a Abacos::Variant
    end
  end
end
