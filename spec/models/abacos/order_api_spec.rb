# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::OrderAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSPedidos+./).should be_true
  end

  describe '#export_order' do
  end
  
  describe '#insert_order' do
    let(:fake_data) { {:fake_data => :order} }
    let(:fake_order) { double :order, :parsed_data => fake_data }
    let(:fake_data_with_key) do
      result = fake_data
      result["ChaveIdentificacao"] = Abacos::Helpers::API_KEY
      result
    end
    it 'should call the inserir_pedido web service and return true if it succeeds' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :inserir_pedido, fake_data_with_key).and_return({:resultado_operacao => {:tipo => 'tdreSucesso'}})
      described_class.insert_order(fake_order).should be_true
    end

    it 'should raise an error if the call fails' do
      described_class.stub(:call_webservice).and_return({:resultado_operacao => {:tipo => 'tdreErro'}})
      expect {
        described_class.insert_order(nil)
      }.to raise_error
    end
  end
end
