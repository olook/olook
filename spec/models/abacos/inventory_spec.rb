# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Inventory do
  let(:downloaded_inventory) { load_abacos_fixture :inventory }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_inventory }
  subject { described_class.new parsed_data }

  describe '#integrate' do
    it "should raise and error if the related Variant doesn't exist" do
      expect {
        ::Variant.should_receive(:find_by_number).with(subject.number).and_return(nil)
        subject.integrate
      }.to raise_error "Inventory is related with Variant number #{subject.number}, but it doesn't exist"
    end

    it 'should update the variant inventory and integrate it' do
      mock_variant = mock_model(::Variant)
      mock_variant.should_receive(:'inventory=').with(subject.inventory)
      mock_variant.should_receive(:'save!')
      ::Variant.should_receive(:find_by_number).with(subject.number).and_return(mock_variant)

      Abacos::ProductAPI.should_receive(:confirm_inventory).with(subject.integration_protocol)
      
      subject.integrate
    end
  end

  describe '#parse_abacos_data' do
    it '#integration_protocol' do
      subject.integration_protocol.should == "BD48CBE2-B732-46C5-97F8-F49EED9BED20"
    end
    it '#number' do
      subject.number.should == "38"
    end
    it '#inventory' do
      subject.inventory.should == 7
    end
  end
end
