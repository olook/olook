# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ProductAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSProdutos+./).should be_true
  end

  it '#download_xml' do
    described_class.should_receive(:call_webservice).with(described_class.wsdl, :method).and_return(:ws_result)
    described_class.should_receive(:parse_nested_data).with(:ws_result, :key)
    described_class.download_xml(:method, :key)
  end

  describe '#confirm_integration' do
    let(:protocol) { 'XYZ-ABC-123' }

    it 'should return true if the call was sucessfull' do
      Rails.env.stub(:'production?').and_return(true)
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :confirmar_recebimento_resource, {"ProtocoloResource" => 'XYZ-ABC-123'}).and_return({:tipo => 'tdreSucesso'})
      described_class.confirm_integration(:resource, protocol).should be_true
    end
    it 'should raise and error if call failed' do
      Rails.env.stub(:'production?').and_return(true)
      described_class.should_receive(:call_webservice).and_return({})
      expect {
        described_class.confirm_integration(:resource, protocol)
      }.to raise_error
    end

    describe 'specific confirmations' do
      it '#confirm_product' do
        described_class.should_receive(:confirm_integration).with(:produto, protocol)
        described_class.confirm_product protocol
      end
      it '#confirm_inventory' do
        described_class.should_receive(:confirm_integration).with(:estoque, protocol)
        described_class.confirm_inventory protocol
      end
      it '#confirm_price' do
        described_class.should_receive(:confirm_integration).with(:preco, protocol)
        described_class.confirm_price protocol
      end
    end
  end

  describe '#download_products', vcr: {:cassette_name => 'ProdutosDisponiveis', :record => :once} do
    it "should products that are available to integration" do
      products = described_class.send :download_products
      products.should be_kind_of(Array)
      products.length.should == 461
    end
  end
end
