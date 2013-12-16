describe TransportShippingService do

  before do
    @defaut_transport_service = {
      :price => 0.0,
      :cost => 0.0,
      :delivery_time => 2,
      :shipping_service_id => 2,
      :shipping_service_priority => "1",
      :cost_for_free => ''
    }
    @transport_service = TransportShippingService.new([@defaut_transport_service])
  end

  context "when have one transport shipping" do
    it "return one shipping transport" do
      expect(@transport_service.choose_better_transport_shipping.count).to eql 1
    end

    it "return same transport shipping info that was initialize" do
      expect(@transport_service.choose_better_transport_shipping).to eql [@defaut_transport_service]
    end
  end
end
