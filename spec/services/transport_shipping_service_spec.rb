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
  end

  context "when have one transport shipping" do
    before do
      @transport_service = TransportShippingService.new([@defaut_transport_service])
    end
    it "return one shipping transport" do
      expect(@transport_service.choose_better_transport_shipping.count).to eql 1
    end

    it "return same transport shipping info that was initialize" do
      expect(@transport_service.choose_better_transport_shipping).to eql [@defaut_transport_service]
    end
  end

  context "when have more than one transport shipping" do
    before do
      @transport_service_1 = {
        :price => 5.0,
        :cost => 1.0,
        :delivery_time => 1,
        :shipping_service_id => 4,
        :shipping_service_priority => "2",
        :cost_for_free => ''
      }
    end
    context "and have two possible choices" do
      before do
        @transport_service = TransportShippingService.new([@defaut_transport_service, @transport_service_1])
      end
      it "return two transport shipping ordering with cost" do
        expect(@transport_service.choose_better_transport_shipping).to eql [@defaut_transport_service, @transport_service_1]
      end
    end
    context "and have tree possible choices" do
      before do
        @transport_service_2 = {
          :price => 5.0,
          :cost => 4.0,
          :delivery_time => 1,
          :shipping_service_id => 4,
          :shipping_service_priority => "3",
          :cost_for_free => ''
        }
        @transport_service = TransportShippingService.new([@defaut_transport_service, @transport_service_1,@transport_service_2])
      end
      it "return two transport shipping ordering with cost" do
        expect(@transport_service.choose_better_transport_shipping).to eql [@defaut_transport_service, @transport_service_1]
      end
    end
  end
end
