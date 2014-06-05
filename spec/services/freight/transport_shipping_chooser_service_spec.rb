describe Freight::TransportShippingChooserService do
  before do
    @shipping = FactoryGirl.build(:shipping)
  end
  context "When have one shipping" do
    it "return formated hash" do
      ship = {default_shipping: { price: '15.99'.to_d, cost: '9.99'.to_d, :delivery_time=>5, :shipping_service_id=>1}}
      expect(described_class.new([@shipping]).perform).to eql(ship)
    end
    context "and dont receive any attributes" do
      it "return default value from freight calculator" do
        @shipping_without_attribute = FactoryGirl.build(:shipping, cost: nil)
        ship = {default_shipping: { price: '15.99'.to_d, cost: FreightCalculator::DEFAULT_FREIGHT_COST.to_d, :delivery_time=>5, :shipping_service_id=>1}}
        expect(described_class.new([@shipping_without_attribute]).perform).to eql(ship)
      end
    end
  end
  context "When there is more than one shippings" do
    before do
      @better_cost_shipping = FactoryGirl.build(:shipping, cost: '4.99',shipping_service_id: 2 )
    end
    it "return better shipping" do
      ship = {default_shipping: { price: '15.99'.to_d, cost: '4.99'.to_d, :delivery_time=>5, :shipping_service_id=>2}}
      expect(described_class.new([@shipping,@better_cost_shipping]).perform).to eql(ship)
    end
    context "and there is fast shipping" do
      before do
        @fast_shipping = FactoryGirl.build(:shipping, delivery_time: 1, cost: '14.99',shipping_service_id: 3)
      end
      it "return default and fast shippings" do
        ship = {default_shipping: { price: '15.99'.to_d, cost: '4.99'.to_d, :delivery_time=>5, :shipping_service_id=>2},
                fast_shipping: {price: '15.99'.to_d, cost: '14.99'.to_d, :delivery_time=>1, :shipping_service_id=>3}}
        expect(described_class.new([@shipping,@better_cost_shipping,@fast_shipping]).perform).to eql(ship)
      end
    end
  end

end
