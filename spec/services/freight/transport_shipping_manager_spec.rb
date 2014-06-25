describe Freight::TransportShippingManager do
  before do
    @shipping = FactoryGirl.build(:shipping)
  end

  context "When there isn't shippings" do
    it "return default info" do
      expect(described_class.new("08730810", "79.9", []).default).to eql(Freight::TransportShippingManager::DEFAULT_FREIGHT)
    end
  end
  context "When there is one shipping" do
    ship = { price: '15.99'.to_d, cost: '9.99'.to_d, :delivery_time=>9, :shipping_service_id=>1}
    it "return shipping" do
      expect(described_class.new("08730810", "79.9", [@shipping]).default).to eql(ship)
    end
  end
  context "When there is more than one shipping" do
    it "return shipping" do
      fast = FactoryGirl.build(:shipping, cost: '4.99')
      ship = { price: fast.income.to_d, cost: fast.cost.to_d, :delivery_time=>9, :shipping_service_id=>1}
      expect(described_class.new("08730810", "79.9", [@shipping, fast]).default).to eql(ship)
    end
  end
  context "When there there is free freight policy" do
    it "return shipping" do
      fast = FactoryGirl.build(:shipping, cost: '4.99')
      expect(described_class.new("08730810", "79.9", [@shipping, fast]).default[:price]).to eql('0.0'.to_d)
    end
  end
end
