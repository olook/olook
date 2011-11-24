# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Price do
  let(:downloaded_price) { load_abacos_fixture :price }
  subject { described_class.new downloaded_price }
  
  describe 'attributes' do
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
