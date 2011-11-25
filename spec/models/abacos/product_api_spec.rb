# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ProductAPI do
  it '#download_xml' do
    ws_result = {:key => 'ws_result'}
    described_class.should_receive(:call_webservice).with(Abacos::ProductAPI::WSDL, :method).and_return(ws_result)
    described_class.download_xml(:method, :key).should == ['ws_result']
  end

  describe '#confirm_integration' do
    it 'should return true if the call was sucessfull' do
      described_class.should_receive(:call_webservice).with(Abacos::ProductAPI::WSDL, :confirmar_recebimento_resource, {"ProtocoloResource" => 'XYZ-ABC-123'}).and_return({:tipo => 'tdreSucesso'})
      described_class.confirm_integration(:resource, 'XYZ-ABC-123').should be_true
    end
    it 'should return true if the call was sucessfull' do
      described_class.should_receive(:call_webservice).and_return({})
      expect {
        described_class.confirm_integration(:resource, 'XYZ-ABC-123')
      }.to raise_error
    end
  end

  describe '#download_products' do
    use_vcr_cassette 'ProdutosDisponiveis', :record => :once

    it "should products that are available to integration" do
      products = described_class.send :download_products
      products.should be_kind_of(Array)
      products.length.should == 144
    end
  end
end
