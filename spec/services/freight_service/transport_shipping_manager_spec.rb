require File.expand_path(File.join(File.dirname(__FILE__), '../../../app/services/freight_service/transport_shipping_manager'))
describe FreightService::TransportShippingManager do
  context "When there isn't shippings" do
    subject { described_class.new("08730810", "79.9", []) }
    it "return default info" do
      subject.should_receive(:default_freight).and_return(:default_freight)
      expect(subject.default).to eql(:default_freight)
    end
  end
  context "When there shipping" do
    subject { described_class.new("08730810", "79.9", @shippings, freight_calculator: FR) }
    before do
      @shippings = [double('Shipping', cost: 10, income: 15, delivery_time: 2, shipping_service_id: 1)]
      @ship = { price: 15, cost: 10, :delivery_time => 4, :shipping_service_id => 1 }
      stub_const('FR::DEFAULT_INVENTORY_TIME', 2)
    end
    context "with one" do
      it "return shipping" do
        expect(subject.default).to eql(@ship)
      end
    end
    context "with more than one" do
      it "return shipping" do
        subject
        cost_less = double('Shipping', cost: 5, income: 15, delivery_time: 5, shipping_service_id: 1)
        @shippings.push cost_less
        ship = { price: cost_less.income, cost: cost_less.cost, :delivery_time => 7, :shipping_service_id=>1}
        expect(subject.default).to eql(ship)
      end
    end
    context "When there there is free freight policy" do
      it "return shipping" do
        subject.should_receive(:is_free_cost?).and_return(true)
        expect(subject.default[:price]).to eql('0.0')
      end
    end
  end
end
