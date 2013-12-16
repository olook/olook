describe TransportShippingService do

  before do
    defaut_transport_service = {
      :price => 0.0,
      :cost => 0.0,
      :delivery_time => 2,
      :shipping_service_id => 2,
      :shipping_service_priority => "1",
      :cost_for_free => ''
    }
    @transport_service = TransportShippingService.new([defaut_transport_service])
  end

  it "return one shipping transport if array have one transport service" do
    expect(@transport_service.choose_better_transport_shipping.count).to eql 1
  end
end
