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
end
