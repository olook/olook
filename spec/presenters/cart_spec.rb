require "spec_helper"

describe Cart do
  let(:order) {FactoryGirl.create(:order)}
  let(:total_with_freight) { 48.83 }
  let(:total) { 45.89 }
  let(:credits) { 1.28 }
  subject { Cart.new(order)}

  before :each do
    order.stub(:total_with_freight).and_return(total_with_freight)
    order.stub(:total).and_return(total)
    order.stub(:credits).and_return(credits)
  end

  it "should return the total" do
    subject.total.should == total_with_freight
  end

  it "should return the subtotal" do
    subject.subtotal.should == order.total + credits
  end

  it "should return the subtotal when the credits is nil" do
    order.stub(:credits).and_return(nil)
    subject.subtotal.should == order.total
  end

  it "should return the discount" do
    subject.discount.should == order.credits
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
