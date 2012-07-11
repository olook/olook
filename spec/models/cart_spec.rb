require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_one(:order) }
  it { should have_many(:items) }
  
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }
  
  let(:price_mock) do
    price = mock
    price.stub(final_price: 100)
    price.stub(discounts: {
      coupon:    {value: 25},
      credits:   {value: 30},
      promotion: {value: 40}
    })
    price
  end
  
  context "when add item" do
    it "should return nil when has gift product in cart and is not gift" do
      cart = subject
      cart.stub(has_gift_items?: true)
      cart.add_item(basic_shoe_35).should eq(nil)
    end
    
    it "should return nil when no has available for quantity" do
      basic_shoe_35.stub(available_for_quantity?: false)
      subject.add_item(basic_shoe_35).should eq(nil)
    end
    
    it "should add item" do
      expect {
      }.to change(CartItem.count).by(1)
    end
    
    it "should add item with gift discount"

    it "should update quantity when product exist in cart item"
  end
  
  context "when remove item" do
    "should remove when variant exists in cart"
    "should not raise error when variant not exists in cart"
  end
  
  it "should sum quantity of cart items" do
    
  end

  it "should return true for gift_wrap? when gift_wrap is nil" do
    subject.gift_wrap?.should eq(false)
  end

  it "should return true when gift_wrap is '1'" do
    cart = subject
    cart.gift_wrap = '1'
    cart.gift_wrap?.should eq(true)
  end
  
  it "should clear all cart items"

  it "should return true when at least one gift item"

  it "should return false when no has gift item"

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