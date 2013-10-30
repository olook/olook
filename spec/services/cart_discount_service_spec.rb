require File.expand_path(File.join(File.dirname(__FILE__), '../../app/services/cart_discount_service'))
describe CartDiscountService do
  before do
    @cart = double('cart')
    @cart.stub(:coupon).and_return nil
    @cart.stub(:sub_total).and_return(99.0)
  end

  context "with cart only" do
    before do
      @service = CartDiscountService.new(@cart)
    end
    context "#calculate" do
      it "returns cart total price" do
        @cart.stub(:total_price).and_return(99.0)
        expect(@service.calculate).to eql(99.0)
      end
    end
    context "#final_price" do
      it "calculates if doesn`t have price" do
        @cart.stub(:sub_total).and_return(79.0)
        expect(@service.final_price).to eql(79.0)
      end
    end
  end

  context "with coupon" do
    before do
      @cart.stub(:coupon).and_return(double('coupon'))
      @service = CartDiscountService.new(@cart)
    end

    context "invalid" do
      it "doesnt apply coupon" do
        @cart.coupon.should_receive(:eligible_for_cart?).with(@cart).and_return(false)
        expect(@service.final_price).to eql(99.0)
      end
    end
    context "Valid" do
      it "applies percentage coupon" do
        @cart.coupon.should_receive(:eligible_for_cart?).with(@cart).and_return(true)
        @cart.coupon.stub(:calculate_for_cart).and_return(69.3)
        @cart.coupon.stub(:is_percentage?).and_return(true)
        expect(@service.final_price).to eql(69.3)
      end
      it "applies value coupon" do
        @cart.coupon.should_receive(:eligible_for_cart?).with(@cart).and_return(true)
        @cart.coupon.stub(:calculate_for_cart).and_return(69.0)
        @cart.coupon.stub(:is_percentage?).and_return(false)
        expect(@service.final_price).to eql(69.0)
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