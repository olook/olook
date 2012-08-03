require "spec_helper"

describe CartService do

  xit "should return true for gift_wrap? when gift_wrap is nil" do
    subject.gift_wrap?.should eq(false)
  end

  xit "should return true when gift_wrap is '1'" do
    cart = subject
    cart.gift_wrap = '1'
    cart.gift_wrap?.should eq(true)
  end
  
  xit "should return total price" do
    subject.total.should eq(100)
  end

  xit "should return freight price" do
    subject.freight_price.should eq(0)
  end

  xit "should return coupon discount" do
    subject.coupon_discount.should eq(25)
  end

  xit "should return credits discount" do
    subject.credits_discount.should eq(30)
  end

  xit "should return promotion discount" do
    subject.promotion_discount.should eq(40)
  end
  

end