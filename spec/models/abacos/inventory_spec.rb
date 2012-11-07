# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Inventory do
  let(:downloaded_inventory) { load_abacos_fixture :inventory }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_inventory }
  subject { described_class.new parsed_data }

  describe '#integrate' do
    it "should raise and error if the related Variant doesn't exist" do
      Airbrake.should_receive(:notify).with({
        :error_class   => "Invetory",
        :error_message => "Inventory is related with Variant number #{subject.number}, but it doesn't exist"
      })
      ::Variant.should_receive(:find_by_number).with(subject.number).and_return(nil)
      subject.integrate.should eq(nil)
    end

    it 'should update the variant inventory and integrate it' do
      mock_variant = mock_model(::Variant)
      mock_variant.should_receive(:'inventory=').with(subject.inventory)
      mock_variant.should_receive(:'update_initial_inventory_if_needed')
      mock_variant.should_receive(:'save!')
      ::Variant.should_receive(:find_by_number).with(subject.number).and_return(mock_variant)

      subject.should_receive(:confirm_inventory)
      
      subject.integrate
    end
  end
  
  describe '#confirm_inventory' do
    let(:fake_protocol) { 'PROT-123-INV' }
    it 'should add a task on the queue to integrate' do
      subject.stub(:integration_protocol).and_return(fake_protocol)
      Resque.should_receive(:enqueue).with(Abacos::ConfirmInventory, fake_protocol)
      subject.confirm_inventory
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
