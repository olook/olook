require File.expand_path(File.join(File.dirname(__FILE__), '../../app/services/product_discount_service'))
describe ProductDiscountService do
  before do
    @product = double('product')
    @product.stub(:price).and_return(99.0)
    @product.stub(:retail_price).and_return(99.0)
  end
  context "with product only" do
    before do
      @service = ProductDiscountService.new(@product)
    end
    context "#calculate" do
      it "returns product price without markdown" do
        expect(@service.calculate).to eql(99.0)
      end
      it "returns product price with markdown" do
        @product.should_receive(:retail_price).any_number_of_times.and_return(79.0)
        expect(@service.calculate).to eql(79.0)
      end
    end
    context "#final_price" do
      it "calculates if doesn`t have price" do
        @product.should_receive(:retail_price).any_number_of_times.and_return(79.0)
        expect(@service.final_price).to eql(79.0)
      end
    end
  end
  context "with coupon" do
    before do
      @coupon = double('coupon')
      @cart = double('cart')
      @service = ProductDiscountService.new(@product, cart: @cart, coupon: @coupon)
    end

    context "invalid" do
      it "doesnt apply coupon" do
        @coupon.should_receive(:eligible_for_product?).with(@product, cart: @cart).and_return(false)
        expect(@service.calculate).to eql(99.0)
      end
    end
    context "Valid" do
      it "applies percentage coupon" do
        @coupon.should_receive(:eligible_for_product?).with(@product, cart: @cart).and_return(true)
        @coupon.should_receive(:calculate_for_product).and_return(69.3)
        expect(@service.calculate).to eql(69.3)
      end
      it "applies value coupon" do
        @coupon.should_receive(:eligible_for_product?).with(@product, cart: @cart).and_return(false)
        expect(@service.calculate).to eql(99.0)
      end
    end
  end
  context "with promotion" do
    before do
      @promotion = double('promotion')
      @service = ProductDiscountService.new(@product, promotion: @promotion)
    end

    context "invalid" do
      it "doesn't apply promotion discount" do
       @promotion.should_receive(:eligible_for_product?).and_return false
       expect(@service.calculate).to eq(99.0)
      end
    end

    context "valid" do
      it "applies promotion discount" do
        @promotion.should_receive(:eligible_for_product?).and_return true
        @promotion.should_receive(:calculate_for_product).and_return(40.0)
        expect(@service.calculate).to eq(40.0)
      end
    end
  end
end
