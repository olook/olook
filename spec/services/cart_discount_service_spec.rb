require File.expand_path(File.join(File.dirname(__FILE__), '../../app/services/cart_discount_service'))
describe CartDiscountService do
  before do
    @cart = double('cart')
    @cart.stub(:sub_total).and_return(99.0)
  end

  context "with cart only" do
    before do
      @service = CartDiscountService.new(@cart)
    end
    context "#calculate" do
      it "returns cart total price" do
        expect(@service.calculate).to eql(99.0)
      end
    end
    context "#final_price" do
      it "calculates if doesn`t have price" do
        expect(@service.final_price).to eql(99.0)
      end
    end
  end

  context "with coupon" do
    before do
      @coupon = double('coupon')
      @service = CartDiscountService.new(@cart, coupon: @coupon)
    end

    context "invalid" do
      it "doesnt apply coupon" do
        @coupon.should_receive(:eligible_for_cart?).with(@cart).and_return(false)
        expect(@service.calculate).to eql(99.0)
      end
    end
    context "Valid" do
      it "applies coupon" do
        @coupon.should_receive(:eligible_for_cart?).with(@cart).and_return(true)
        @coupon.should_receive(:calculate_for_cart).with(@cart).and_return(69.0)
        expect(@service.calculate).to eql(69.0)
      end
    end
  end
  context "with promotion" do
    before do
      @promotion = double('promotion')
      @service = CartDiscountService.new(@cart, promotion: @promotion)
    end

    context "invalid" do
      it "doesn't apply promotion discount" do
       @promotion.should_receive(:eligible_for_cart?).and_return false
       expect(@service.calculate).to eq(99.0)
      end
    end

    context "valid" do
      it "applies promotion discount" do
        @promotion.should_receive(:eligible_for_cart?).and_return true
        @promotion.should_receive(:calculate_for_cart).and_return(40.0)
        expect(@service.calculate).to eq(40.0)
      end
    end
  end
end
