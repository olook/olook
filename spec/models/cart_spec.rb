require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_one(:order) }
  it { should have_many(:items) }
  
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }

  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:cart_with_items) { FactoryGirl.create(:cart_with_items) }
  let(:cart_with_gift) { FactoryGirl.create(:cart_with_gift) }
  
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
      basic_shoe_35.should_not_receive(:gift_price)
      expect {
        item = cart.add_item(basic_shoe_35, 2)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(2)
        item.price.should eq(basic_shoe_35.product.price)
        item.retail_price.should eq(basic_shoe_35.product.retail_price)
        item.gift_position.should eq(0)
        item.gift.should eq(false)
        item.discount_source.should eq(:legacy)
      }.to change{CartItem.count}.by(1)
    end
    
    it "should add item with gift discount" do
      gift_retail_price = 100
      gift_position = 2
      basic_shoe_35.should_receive(:gift_price).with(gift_position).and_return(gift_retail_price)
      expect {
        item = cart.add_item(basic_shoe_35, 1, gift_position, true)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(1)
        item.price.should eq(basic_shoe_35.product.price)
        item.retail_price.should eq(gift_retail_price)
        item.gift_position.should eq(gift_position)
        item.gift.should eq(true)
        item.discount_source.should eq(:legacy)
      }.to change{CartItem.count}.by(1)
    end

    it "should update quantity when product exist in cart item"
  end
  
  context "when remove item" do
    it "should remove when variant exists in cart"
    it "should not raise error when variant not exists in cart"
  end
  
  it "should sum quantity of cart items" do
    cart_with_items.items_total.should eq(2)
  end

  it "should return true for gift_wrap? when gift_wrap is nil" do
    subject.gift_wrap?.should eq(false)
  end

  it "should return true when gift_wrap is '1'" do
    cart = subject
    cart.gift_wrap = '1'
    cart.gift_wrap?.should eq(true)
  end
  
  it "should clear all cart items" do
    cart = cart_with_items
    expect {
      cart_with_items.clear
    }.to change{CartItem.count}.by(-1)
  end

  it "should return true when at least one gift item" do
    cart_with_gift.has_gift_items?.should be(true)
  end

  it "should return false when no has gift item" do
    cart_with_items.has_gift_items?.should be(false)
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