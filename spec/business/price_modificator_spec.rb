require 'lightweight_spec_helper'

require './app/services/promotion_service'
require './app/business/price_modificator'
require './app/business/discount'


describe PriceModificator do
  let(:cart) {
    price = 10

    stub(:cart,
         :items => [ double('cart_item', :price => price, :total_price => 3*price, :retail_price => price, :original_price => price, :original_retail_price => price, :gift => false),
                     double('cart_item', :price => 20   , :total_price => 20, :retail_price => price, :original_price => 20   , :original_retail_price => price, :gift => false)],
         :used_coupon => double(:coupon, :is_percentage? => true , :value => 25, :try => 'foobar'),
         :used_promotion => double(:promo, :try => 30),
         :gift_wrap? => true,
         :credits => 15,
         :freight => double(:price => 15)
        )
  }

  subject { PriceModificator.new(cart) }

  before do
    described_class.any_instance.stub(:minimum_value).and_return(5)
    described_class.any_instance.stub(:increment_from_gift).and_return(5)
  end

  describe 'public interface' do
    subject { PriceModificator.new(stub)  }

    it 'should receive a parameter' do
      expect { PriceModificator.new(stub) }.to_not raise_exception
    end

    it 'should respond_to public interface methods' do
      #modificators
      subject.should respond_to(:discounts)
      subject.should respond_to(:increments)

      #finals
      subject.should respond_to(:original_price)
      subject.should respond_to(:discounted_price)
      subject.should respond_to(:final_price)

      #items
      subject.should respond_to(:items_discounts_total)
      subject.should respond_to(:items_discount_conflict)
      subject.should respond_to(:items_discount_conflict?)
      subject.should respond_to(:items_discount)
    end
  end

  describe '.discounts' do
    it 'should limit credits based on credits based on total and discounts' do
      subject.discounts[:credits][:value].should == 15
    end

    it 'product_discounts keys should be the cart items' do
      subject.discounts[:product_discount].keys.should == cart.items
    end

    it 'product_discounts values should be Discounts of the items' do
      subject.discounts[:product_discount].values.map(&:item).should == cart.items
    end

    it 'should show only money_coupon or the products discounts depending on who is bigger' do
      subject.discounts.keys == [:product_discount, :credits]
      subject.stub( :used_coupon => double(:coupon, :is_percentage? => false, :value => 150, :try => 'foobar'))
      subject.discounts.keys == [:money_coupon, :credits]
    end

    it 'should limit coupon value' do
      subject.stub( :used_coupon => double(:coupon, :is_percentage? => false, :value => 150, :try => 'foobar'))
      subject.discounts[:money_coupon][:value].should == 45
    end

    it 'should only apply gift discounts if item is gift' do
      gift_item = double('cart_item', :price => 25.0, :total_price => 30.0, :retail_price => 10.0, :original_price => 25.0, :original_retail_price => 10.0, :gift => true)
      subject.stub( :used_coupon => double(:coupon, :is_percentage? => false, :value => 150, :try => 'foobar'))
      subject.stub(:items => [ gift_item ])

      subject.discounts.keys.should == [:product_discount, :credits]
      subject.discounts[:product_discount][gift_item].origin.should == :gift
      subject.discounts[:product_discount][gift_item].value.should == 15.0
      subject.discounts[:product_discount][gift_item].percentage.should == 40.0
      subject.discounts[:product_discount][gift_item].item.should == gift_item
    end
  end


  describe '.increments' do
    it 'should return the freight and the gift wrap price' do
        pending
      subject.increments
    end
  end

  describe '.original_price' do
    it 'should return the sum of cart items prices' do
      subject.original_price.should == 50
    end
  end

  describe '.discounted_price' do
    it 'should return the sum of cart items prices' do
        pending
      subject.discounted_price
    end
  end

  describe '.final_price' do
    it 'should return the price minus the discount plus the increments' do
        pending
      subject.final_price
    end
  end


  describe '.items_discounts_total' do
    it 'should work' do
        pending
      subject.items_discounts_total
    end
  end

  describe '.items_discount_conflict' do
    it 'should work' do
        pending
      subject.items_discount_conflict
    end
  end

  describe '.items_discount_conflict?' do
    it 'should work' do
        pending
      subject.items_discount_conflict?
    end
  end

  describe '.items_discount' do
    it 'should work' do
        pending
      subject.items_discount
    end
  end
end
