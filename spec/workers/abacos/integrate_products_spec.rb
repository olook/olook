# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::IntegrateProducts do
  use_vcr_cassette 'ProdutosDisponiveis', :record => :once
  let(:downloaded_product) { load_abacos_fixture :product }
  let(:downloaded_variant) { load_abacos_fixture :variant }

  describe "#perform" do
    DownloadProducts.download_products
  end
  
  describe "#parse_abacos_product" do
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
