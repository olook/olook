require "spec_helper"

describe Cart do
  let(:order) {FactoryGirl.create(:order)}
  let(:freight) {{:price => 2.39}}
  let(:total) { 45.89 }
  let(:credits) { 1.28 }
  subject { Cart.new(order, freight)}

  before :each do
    order.stub(:total).and_return(total)
    order.stub(:credits).and_return(credits)
  end

  it "should return the total" do
    subject.total.should == total
  end

  it "should return the subtotal" do
    subject.subtotal.should == order.total + credits
  end

  it "should return the discount" do
    subject.discount.should == order.credits
  end

  it "should return the freight price" do
    subject.freight_price.should == freight[:price]
  end

  it "should return 0 when the freight is nil" do
    cart = Cart.new(order)
    cart.freight_price.should == 0
  end
end
