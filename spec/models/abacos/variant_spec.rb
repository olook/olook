# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Variant do
  let(:downloaded_variant) { load_abacos_fixture :variant }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_variant }
  subject { described_class.new parsed_data }
  
  it '#attributes' do
    subject.attributes.should == {  number:             subject.number,
                                    description:        subject.description,
                                    display_reference:  subject.display_reference,
                                    is_master:          false }
  end

  describe '#integrate' do
    it 'should create, merge the imported attributes on the variant and integrate it' do
      mock_product = mock_model ::Product
      ::Product.should_receive(:find_by_model_number).with(subject.model_number).and_return(mock_product)

      mock_variant = mock_model(::Variant)
      mock_variant.should_receive(:update_attributes).with(subject.attributes)
      mock_variant.should_receive(:'save!')

      mock_product.stub_chain(:variants, :find_by_number).with(subject.number).and_return(mock_variant)

      Abacos::ProductAPI.should_receive(:confirm_product).with(subject.integration_protocol)
      
      subject.integrate
    end
    
    it "should raise and error if the model_number doesn't exist" do
      expect {
        ::Product.stub(:find_by_model_number).with(subject.model_number).and_return(nil)
        subject.integrate
      }.to raise_error "Product with model_number #{subject.model_number} is related to variant number #{subject.number} but it doesn't exist"
    end
  end
  
  describe 'class methods' do
    describe '#parse_abacos_data' do
      it '#integration_protocol' do
        subject.integration_protocol.should == "7D2D3CB3-ADD1-4144-946B-66A57B2BEA60"
      end

      it '#model_number' do
        subject.model_number.should == "37"
      end
      it '#number' do
        subject.number.should == "38"
      end
      it '#description' do
        subject.description.should == "33"
      end
      it '#display_reference' do
        subject.display_reference.should == "size-33"
      end
    end

    describe '#parse_description' do
      it 'should return TAMANHO value when it exists' do
        described_class.should_receive(:find_in_descritor_pre_definido).with({}, 'TAMANHO')
        described_class.parse_description({})
      end
      it "should return 'Tamanho único' when TAMANHO doesn't exist" do
        described_class.stub(:find_in_descritor_pre_definido).and_return('')
        described_class.parse_description({}).should == 'Tamanho único'
      end
    end

    describe '#parse_display_reference' do
      it "should return size-X if it's a shoe" do
        result = described_class.parse_display_reference 'X', Category::SHOE
        result.should == 'size-X'
      end
      it "should return single-size if it isn't a shoe" do
        result = described_class.parse_display_reference 'X', Category::BAG
        result.should == 'single-size'
      end
    end
  end
end
