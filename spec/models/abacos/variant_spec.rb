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
  end
end
