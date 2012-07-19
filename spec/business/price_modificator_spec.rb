require 'lightweight_spec_helper'

require './app/services/promotion_service'
require './app/business/price_modificator'
require './app/business/discount'


describe PriceModificator do
  let(:cart) {
    price = 10

    stub(:cart,
         :items => [ double('cart_item', :price => price, :retail_price => price, :original_price => price, :original_retail_price => price),
                     double('cart_item', :price => 20   , :retail_price => price, :original_price => 20   , :original_retail_price => price)],
         :used_coupon => double(:coupon, :is_percentage? => true , :value => 30, :try => 'foobar'),
         :used_promotion => double(:promo, :try => 20),
         :gift_wrap? => true,
         :credits => 10,
         :freight => double(:price => 15)
        )
  }

  subject {
    ret_cart = PriceModificator.new(cart)
    ret_cart.stub(:increment_from_gift => 5)
    ret_cart
  }

  before do
    subject.stub!(:minimum_value).and_return(5)
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
    it 'should return the discount list' do
      subject.discounts.keys.should == [:product_discount , :money_coupon , :credits]
    end

    context 'when the maximal discount is 20' do
      before(:each) do
        subject.stub(:max_discount).and_return(20)
      end

      it 'should limit credits based on credits based on total and discounts' do
        pending
      end

      it 'should limit coupon value' do
        pending
      end

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
        pending
      subject.original_price
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
