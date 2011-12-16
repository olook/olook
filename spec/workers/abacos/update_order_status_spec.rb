# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::UpdateOrderStatus do
  describe "#perform" do
    let(:statuses) { [:data_a, :data_b] }
    it "should download and parse order statuses" do
      Abacos::OrderAPI.should_receive(:download_orders_statuses).and_return(statuses)
      
      Abacos::OrderStatus.should_receive(:parse_abacos_data).with(:data_a).and_return(:status_a)
      Abacos::OrderStatus.should_receive(:parse_abacos_data).with(:data_b).and_return(:status_b)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, Abacos::OrderStatus.to_s, :status_a)
      Resque.should_receive(:enqueue).with(Abacos::Integrate, Abacos::OrderStatus.to_s, :status_b)
      
      described_class.perform
    end
  end
end
