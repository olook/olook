require 'spec_helper'
describe CartProfit::CartCalculator do

  before do
    @cart = FactoryGirl.create(:cart_with_1_full_and_1_discount)
  end

  context "when car have items" do
    before do
      @cart.items.first.should_receive(:retail_price).and_return(BigDecimal.new("99,9"))
      @cart.items.last.should_receive(:retail_price).and_return(BigDecimal.new("39,9"))
    end

    it "returns subtotal" do
      expect(described_class.new(@cart).items_subtotal).to eql(BigDecimal.new("237,9"))
    end
    it "returns total" do
      calculator = CartProfit::CartCalculator.new(@cart)
      calculator.should_receive(:user_credits_value).and_return(BigDecimal.new("39,9"))
      expect(calculator.items_total).to eql(BigDecimal.new("198,9"))
    end
  end
end
