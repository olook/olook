# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::DownloadProducts do
  use_vcr_cassette 'ProdutosDisponiveis', :record => :once
  
  it "#download_products, gets products that are available to integration" do
    products = described_class.send :download_products
    products.should be_kind_of(Array)
    products.length.should == 144
  end
end
