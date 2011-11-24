# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Variant do
  let(:downloaded_variant) { load_abacos_fixture :variant }
  subject { described_class.new downloaded_variant }
  
  describe 'attributes' do
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
