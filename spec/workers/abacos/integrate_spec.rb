# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Integrate do
  describe ".perform" do
    let(:mock_klass) { double :klass }
    let(:mock_integratable) { double :integratable }
    let(:parsed_data) { { model_number: '85', number: '42' } }
    before do
      mock_klass.stub_chain(:constantize, :new).with(parsed_data).and_return(mock_integratable)
    end
    it 'calls integrate on the instantiated objects' do
      mock_integratable.should_receive :integrate
      described_class.perform(mock_klass, parsed_data)
    end

    context "exception" do
      before do
        mock_integratable.stub(:integrate).and_raise("Any error")
      end
      context "with only model number" do
        let(:parsed_data) { { model_number: '85' } }
        it "decrements products count to be integrated as failure" do
          Abacos::IntegrateProductsObserver.should_receive(:mark_product_integrated_as_failure!).with("85", "Any error")
          described_class.perform(mock_klass, parsed_data)
        end
      end
      context "with model number and number" do
        it "decrements products count to be integrated as failure" do
          Abacos::IntegrateProductsObserver.should_receive(:mark_product_integrated_as_failure!).with("42", "Any error")
          described_class.perform(mock_klass, parsed_data)
        end
      end
    end
  end
end
