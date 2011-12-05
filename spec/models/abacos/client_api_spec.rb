# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ClientAPI do
  it 'should have the WSDL url pointing to the service' do
    described_class.wsdl.match(/.+AbacosWSClientes+./).should be_true
  end
end
