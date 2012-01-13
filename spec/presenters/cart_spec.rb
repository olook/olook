require "spec_helper"

describe Cart do
  let(:order) {FactoryGirl.create(:order)}
  let(:total_with_freight) { 48.83 }
  let(:total) { 45.89 }
  let(:credits) { 1.28 }
  let(:gift_discount) { 23.28 }
  let(:coupon_discount) { 10.28 }
  let(:line_items_total) { 23.90 }
  subject { Cart.new(order)}

  before :each do
    order.stub(:total_with_freight).and_return(total_with_freight)
    order.stub(:total).and_return(total)
    order.stub(:credits).and_return(credits)
    order.stub(:discount_from_gift).and_return(gift_discount)
    order.stub(:discount_from_coupon).and_return(coupon_discount)
    order.stub(:line_items).and_return([:fake_data])
    order.stub(:line_items_total).and_return(line_items_total)
  end

  it "should return 0 if the order dont have line items" do
    order.stub(:line_items).and_return([])
    cart = Cart.new(order)
    cart.total.should == 0
  end

  it "should return the total" do
    subject.total.should == total_with_freight
  end

  it "should return the subtotal" do
    subject.subtotal.should == line_items_total
  end

  it "should return the credits discount" do
    subject.credits_discount.should == order.credits
  end

  it "should return the gift discount" do
    subject.gift_discount.should == order.discount_from_gift
  end

  it "should return the coupon discount" do
    subject.coupon_discount.should == order.discount_from_coupon
  end

  it "should return the coupon discount" do
    order.stub_chain(:used_coupon, :is_percentage?).and_return(true)
    order.stub_chain(:used_coupon, :value).and_return(percent = 20)
    expected = "#{percent}%"
    subject.coupon_discount_in_percentage.should == expected
  end

  it "should return the freight price" do
    subject.freight_price.should == order.freight_price
  end

  it "should return 0 when the freight is nil" do
    order.stub(:freight).and_return(nil)
    cart = Cart.new(order)
    cart.freight_price.should == 0
  end
end
