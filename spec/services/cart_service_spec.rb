require "spec_helper"

describe CartService do

  it "should return true for gift_wrap? when gift_wrap is nil" do
    subject.gift_wrap?.should eq(false)
  end

  it "should return true when gift_wrap is '1'" do
    cart = subject
    cart.gift_wrap = '1'
    cart.gift_wrap?.should eq(true)
  end
  
  it "should return total price" do
    PriceModificator.should_receive(:new).with(subject).and_return(price_mock)
    subject.total.should eq(100)
  end

  it "should return freight price" do
    subject.freight_price.should eq(0)
  end

  it "should return coupon discount" do
    PriceModificator.should_receive(:new).with(subject).and_return(price_mock)
    subject.coupon_discount.should eq(25)
  end

  it "should return credits discount" do
    PriceModificator.should_receive(:new).with(subject).and_return(price_mock)
    subject.credits_discount.should eq(30)
  end

  it "should return promotion discount" do
    PriceModificator.should_receive(:new).with(subject).and_return(price_mock)
    subject.promotion_discount.should eq(40)
  end
  

end