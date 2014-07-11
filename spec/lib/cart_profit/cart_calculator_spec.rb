require 'spec_helper'
describe CartProfit::CartCalculator do

  before do
    @cart = mock_model(Cart, items: [
      mock_model(CartItem, price: 100, retail_price: 100, quantity: 1),
      mock_model(CartItem, price: 100, retail_price: 80, quantity: 1)
    ])
  end

  context "when cart have items" do
    it "returns subtotal" do
      expect(described_class.new(@cart).items_subtotal).to eq(200.0)
    end
    it "returns total" do
      calculator = CartProfit::CartCalculator.new(@cart)
      calculator.should_receive(:used_credits_value).and_return(30.0)
      calculator.should_receive(:gift_price).and_return(0.0)
      expect(calculator.items_total).to eq(150.0)
    end
  end
end
