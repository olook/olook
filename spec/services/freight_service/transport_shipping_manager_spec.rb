require File.expand_path(File.join(File.dirname(__FILE__), '../../../app/services/freight_service/transport_shipping_manager'))
describe FreightService::TransportShippingManager do
  subject { described_class.new("08730810", "79.9", @shippings, freight_calculator: FR) }
  before do
    stub_const('FR::DEFAULT_INVENTORY_TIME', 2)
    stub_const('FR::DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME', 4)
    stub_const('FR::DEFAULT_FREIGHT_PRICE', 20)
    stub_const('FR::DEFAULT_FREIGHT_COST', 15)
    stub_const('FR::DEFAULT_FREIGHT_SERVICE', 2)
    @shippings = [double('Shipping', cost: 10, income: 15, delivery_time: 7, shipping_service_id: 1)]
  end

  context "when there isn't shippings" do
    before do
      @shippings = []
    end
    it { expect(subject.default).to eql({:price=>20, :cost=>15, :delivery_time=>6, :shipping_service_id=>2}) }
    it { expect(subject.fast).to eql(nil) }
  end

  context "when there is one shipping" do
    it { expect(subject.default).to eql({ price: 15, cost: 10, :delivery_time => 9, :shipping_service_id => 1 }) }
    it { expect(subject.fast).to eql(nil) }
  end

  context "when two or more shippings" do
    context "#default" do
      it "should return cheaper shipping" do
        cheaper = double('Shipping', cost: 5, income: 15, delivery_time: 5, shipping_service_id: 1)
        @shippings.push cheaper
        expect(subject.default).to eql({ price: cheaper.income, cost: cheaper.cost, :delivery_time => 7, :shipping_service_id=>1})
      end
    end

    context "#fast" do
      it "should return nil if cheaper shipping is also faster" do
        cheaper_and_faster = double('Shipping', cost: 5, income: 15, delivery_time: 5, shipping_service_id: 1)
        @shippings.push cheaper_and_faster
        expect(subject.fast).to eql(nil)
      end

      it "should return faster shipping" do
        faster = double('Shipping', cost: 15, income: 25, delivery_time: 2, shipping_service_id: 1)
        @shippings.push faster
        expect(subject.fast).to eql({price: faster.income, cost: faster.cost, delivery_time: 4, shipping_service_id: 1})
      end
    end
  end
  context "When there there is free freight policy" do
    it "return shipping" do
      subject.should_receive(:is_free_cost?).and_return(true)
      expect(subject.default[:price]).to eql(0)
    end
  end
end
