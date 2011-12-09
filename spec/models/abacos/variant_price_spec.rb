# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::VariantPrice do
  let(:downloaded_price) { load_abacos_fixture :variant_price }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_price }
  subject { described_class.new parsed_data }
  
  describe '#integrate' do
    it "should raise and error if the related Variant doesn't exist" do
      expect {
        ::Variant.should_receive(:find_by_number).with(subject.number).and_return(nil)
        subject.integrate
      }.to raise_error "Price is related with Variant number #{subject.number}, but it doesn't exist"
    end

    it 'should update the variant price and integrate it' do
      mock_variant = mock_model(::Variant)
      mock_variant.should_receive(:'price=').with(subject.price)
      mock_variant.should_receive(:'save!')
      ::Variant.should_receive(:find_by_number).with(subject.number).and_return(mock_variant)

      subject.should_receive(:confirm_price)
      
      subject.integrate
    end
  end
  
  describe "#confirm_price" do
    let(:fake_protocol) { 'PROT-123-PRICE' }
    it 'should add a task on the queue to integrate' do
      subject.stub(:integration_protocol).and_return(fake_protocol)
      Resque.should_receive(:enqueue).with(Abacos::ConfirmPrice, fake_protocol)
      subject.confirm_price
    end
  end

  describe '#parse_abacos_data' do
    it '#integration_protocol' do
      subject.integration_protocol.should == "999D8382-BA36-4AB4-A9FC-5BEFA60F58D7"
    end
    it '#number' do
      subject.number.should == "38"
    end
    it '#price' do
      subject.price.should == 69.9
    end
  end
end
