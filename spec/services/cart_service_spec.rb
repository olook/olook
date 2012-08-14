require "spec_helper"

describe CartService do

  let(:gift_wrap_price) { 5.00 }

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
    it "should a valid freight is required"
    it "should a valid user is required"
    it "should create"
    it "should create a promotion when used"
    it "should create a coupon when used"
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