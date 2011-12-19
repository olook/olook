# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::UpdateInventory do
  describe "#perform" do
    it "should call process_product, process_inventory, process_price" do
      described_class.should_receive :process_inventory
      
      described_class.perform
    end
  end

  describe "#process_inventory" do
    it 'should download inventory changes, call parse_abacos_data for received data and enqueue them' do
      Abacos::ProductAPI.should_receive(:download_inventory).and_return([:inventory])
      Abacos::Inventory.should_receive(:parse_abacos_data).with(:inventory).and_return(:parsed_inventory)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, "Abacos::Inventory", :parsed_inventory)
      described_class.process_inventory
    end
  end
end
    

