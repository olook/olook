# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::OrderAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSPedidos+./).should be_true
  end
  
  describe '#export_client' do
    let(:fake_data) { {:fake_data => :client} }
    it 'should call the cadastrar_cliente web service and return true if it succeeds' do
    end
  end
end
