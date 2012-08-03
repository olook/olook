require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_many(:orders) }
  it { should have_many(:items) }
  
  let(:basic_shoe) { FactoryGirl.create(:basic_shoe) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }

  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:cart_with_items) { FactoryGirl.create(:cart_with_items) }
  let(:cart_with_gift) { FactoryGirl.create(:cart_with_gift) }
  
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
        item = cart.add_item(basic_shoe_35, 2)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(2)
        item.gift_position.should eq(0)
        item.gift.should eq(false)
      }.to change{CartItem.count}.by(1)
    end
    
    it "should add item with gift discount" do
      expect {
        item = cart.add_item(basic_shoe_35, 1, 2, true)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(1)
        item.gift_position.should eq(2)
        item.gift.should eq(true)
      }.to change{CartItem.count}.by(1)
    end

    it "should update quantity when product exist in cart item" do
      cart.add_item(basic_shoe_35, 1)
      variant = cart.items.first
      cart.add_item(basic_shoe_35, 10)
      variant.reload.quantity.should eq(10)
    end
  end
  
  context "when remove item" do
    it "should remove when variant exists in cart" do
      cart_for_remove = cart_with_items
      FactoryGirl.create(:cart_item, :cart_id => cart_for_remove.id, :variant_id => basic_shoe_37.id)

      expect {
        cart_for_remove.remove_item basic_shoe_37
      }.to change{CartItem.count}.by(-1)
    end
    
    it "should not raise error when variant not exists in cart" do
      cart_for_remove = cart_with_items
      expect {
        cart_for_remove.remove_item basic_shoe_37
      }.to_not change{CartItem.count}
    end
  end
  
  it "should sum quantity of cart items" do
    cart_with_items.items_total.should eq(2)
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
end