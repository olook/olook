# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Integrate do
  describe "#perform" do
    it 'should call integrate on the instantiated objects' do
      mock_klass = double :klass
      mock_integratable = double :integratable
      mock_integratable.should_receive :integrate
      
      mock_klass.stub_chain(:constantize, :new).with(:parsed_data).and_return(mock_integratable)
      
      described_class.send :perform, mock_klass, :parsed_data
    end
  end
end
