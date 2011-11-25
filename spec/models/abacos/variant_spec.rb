# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Variant do
  let(:downloaded_variant) { load_abacos_fixture :variant }
  subject { described_class.new downloaded_variant }
  
  describe 'attributes' do
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
  
  describe 'helper methods' do
    it '#parse_description' do
      subject.should_receive(:find_in_descritor_pre_definido).with({}, 'TAMANHO')
      subject.send :parse_description, {}
    end

    describe '#parse_display_reference' do
      it "should return size-X if it's a shoe" do
        result = subject.send :parse_display_reference, 'X', Category::SHOE
        result.should == 'size-X'
      end
      it "should return single-size if it isn't a shoe" do
        result = subject.send :parse_display_reference, 'X', Category::BAG
        result.should == 'single-size'
      end
    end
  end
end
