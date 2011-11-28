# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Inventory do
  let(:downloaded_inventory) { load_abacos_fixture :inventory }
  subject { described_class.new downloaded_inventory }

  describe 'attributes' do
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
  
  describe '#integrate' do
    it "should raise and error if the Variant with number doesn't exist" do
      expect {
        ::Variant.should_receive(:find_by_number).with(subject.number).and_return(nil)
        subject.integrate
      }.to raise_error "Inventory is related with Variant number #{subject.number}, but it doesn't exist"
    end

    it 'should create, merge the imported attributes on the variant and integrate it' do
      mock_variant = mock_model(::Variant)
      mock_variant.should_receive(:'inventory=').with(subject.inventory)
      mock_variant.should_receive(:'save!')
      ::Variant.should_receive(:find_by_number).with(subject.number).and_return(mock_variant)

      Abacos::ProductAPI.should_receive(:confirm_inventory).with(subject.integration_protocol)
      
      subject.integrate
    end
  end
end
