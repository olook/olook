# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ClientAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSClientes+./).should be_true
  end
  
  describe '#export_client' do
    let(:fake_data) { {:fake_data => :client} }
    it 'should call the cadastrar_cliente web service and return true if it succeeds' do
      described_class.should_receive(:call_webservice).with(described_class.wsdl, :cadastrar_cliente, fake_data).and_return({:resultado_operacao => {:tipo => 'tdreSucesso'}})
      described_class.export_client(fake_data).should be_true
    end

    it 'should raise an error if the call fails' do
      described_class.stub(:call_webservice).and_return({:resultado_operacao => {:tipo => 'tdreErro'}})
      expect {
        described_class.export_client(nil)
      }.to raise_error
    end
  end
end
