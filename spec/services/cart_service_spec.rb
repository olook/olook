require "spec_helper"

describe CartService do

  let(:gift_wrap_price) { 5.00 }

  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:promotion) { FactoryGirl.create :first_time_buyers }
  let(:coupon_of_value) { FactoryGirl.create :standard_coupon}
  let(:payment) { FactoryGirl.create :debit }
  
  
  it "should return gift wrap price" do
    CartService.gift_wrap_price.should eq(gift_wrap_price)
  end
  
  context "when initialize" do
    it "should set credits to zero when is not supplied" do
      cart_service = CartService.new({})
      cart_service.credits.should eq(0)
    end

    [:cart, :gift_wrap, :coupon, :promotion, :freight, :credits].each do |attribute|
      it "should set #{attribute}" do
        value = mock
        cart_service = CartService.new({attribute => value})
        cart_service.send("#{attribute}").should be(value)
      end
    end
  end
  
  context "insert a order" do
    let(:cart_service) { CartService.new({
      :cart => cart,
      :freight => freight,
    }) }
    
    it "should a valid cart is required" do
      expect {
        CartService.new({}).generate_order!(double(Payment))
      }.to raise_error(ActiveRecord::RecordNotFound, 'A valid cart is required for generating an order.')
    end
    
    it "should a valid freight is required" do
      expect {
        CartService.new({:cart => cart}).generate_order!(double(Payment))
      }.to raise_error(ActiveRecord::RecordNotFound, 'A valid freight is required for generating an order.')
    end
    
    it "should a valid user is required" do
      expect {
        cart.user = nil
        CartService.new({:cart => cart, :freight => freight}).generate_order!(double(Payment))
      }.to raise_error(ActiveRecord::RecordNotFound, 'A valid user is required for generating an order.')
    end
    
    it "should create" do
      expect {
        cart_service = CartService.new({:cart => cart, :freight => freight})
        cart_service.stub(:total_credits_discount => 0)
        cart_service.stub(:total_discount => 10)
        cart_service.stub(:total_increase => 20)
        cart_service.stub(:total => 30)
        cart_service.stub(:subtotal => 40)
        cart_service.stub(:item_price => 10)
        cart_service.stub(:item_retail_price => 20)
        
        order = cart_service.generate_order!(payment)
        
        order.cart.should eq(cart)
        order.payment.should eq(payment)
        order.credits.should eq(0)
        order.user_id.should eq(user.id)
        order.restricted.should eq(false)
        order.gift_wrap.should eq(false)
        order.amount_discount.should eq(10)
        order.amount_increase.should eq(20)
        order.amount_paid.should eq(30)
        order.subtotal.should eq(40)
        order.user_first_name.should eq(user.first_name)
        order.user_last_name.should eq(user.last_name)
        order.user_email.should eq(user.email)
        order.user_cpf.should eq(user.cpf)
        
        cart.items.map do |item|
          line_item = order.line_items.where(
            :variant_id => item.variant.id, 
            :quantity => item.quantity, 
            :gift => item.gift
          ).first
          line_item.price.should eq(10)
          line_item.retail_price.should eq(20)
        end

        freight.each do |key, value|
          order.freight.send("#{key}").should eq(value)
        end
        
      }.to change{Order.count}.by(1)
    end
    
    it "should create a promotion when used" do
      expect {
        cart_service = CartService.new({:cart => cart, :freight => freight, :promotion => promotion})
        
        cart_service.stub(:total_discount_by_type => 20)
        
        order = cart_service.generate_order!(payment)
        
        order.used_promotion.promotion.should be(promotion)
        order.used_promotion.discount_percent.should be(promotion.discount_percent)
        order.used_promotion.discount_value.should eq(20)
        
      }.to change{Order.count}.by(1)
    end
    
    it "should create a coupon when used" do
      expect {
        cart_service = CartService.new({:cart => cart, :freight => freight, :coupon => coupon_of_value})
        cart_service.stub(:total_coupon_discount => 100)
        order = cart_service.generate_order!(payment)
        order.used_coupon.coupon.should be(coupon_of_value)
      }.to change{Order.count}.by(1)
    end
  end
  
  context ".gift_wrap?" do
    it "should return true when gift_wrap is '1'" do
      cart_service = CartService.new({:gift_wrap => '1'})
      cart_service.gift_wrap?.should eq(true)
    end
    
    it "should return false when gift_wrap has any value" do
      cart_service = CartService.new({:gift_wrap => 'anything'})
      cart_service.gift_wrap?.should eq(false)
    end
    
    it "should return false when gift_wrap is nil" do
      cart_service = CartService.new({})
      cart_service.gift_wrap?.should eq(false)
    end
  end
  
  context ".freight_price" do
    it "should return zero when freight is not available" do
      cart_service = CartService.new({})
      cart_service.freight_price.should eq(0)
    end
    
    it "should return zero when price is not available" do
      cart_service = CartService.new({:freight => {}})
      cart_service.freight_price.should eq(0)
    end
    
    it "should return price" do
      cart_service = CartService.new({:freight => {:price => 10.0}})
      cart_service.freight_price.should eq(10.0)
    end
  end

  context ".freight_state" do
    it "should return empty when freight is not available" do
      cart_service = CartService.new({})
      cart_service.freight_state.should eq("")
    end
    
    it "should return empty when state is not available" do
      cart_service = CartService.new({:freight => {}})
      cart_service.freight_state.should eq("")
    end
    
    it "should return state" do
      cart_service = CartService.new({:freight => {:state => "XPTO"}})
      cart_service.freight_state.should eq("XPTO")
    end
  end

  context ".freight_city" do
    it "should return empty when freight is not available" do
      cart_service = CartService.new({})
      cart_service.freight_city.should eq("")
    end
    
    it "should return empty when city is not available" do
      cart_service = CartService.new({:freight => {}})
      cart_service.freight_city.should eq("")
    end
    
    it "should return city" do
      cart_service = CartService.new({:freight => {:city => "XPTO2.0"}})
      cart_service.freight_city.should eq("XPTO2.0")
    end
  end
  
  context ".total_increase" do
    it "should return zero when no has freight and gift wrap" do
      cart_service = CartService.new({})
      cart_service.total_increase.should eq(0)
    end
    
    it "should sum gift wrap" do
      cart_service = CartService.new({:gift_wrap => '1'})
      cart_service.total_increase.should eq(gift_wrap_price)
    end
    
    it "should sum freight price" do
      cart_service = CartService.new({:freight => {:price => 10.0}})
      cart_service.total_increase.should eq(10.0)
    end
  end
  

end