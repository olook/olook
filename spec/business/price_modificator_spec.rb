require 'lightweight_spec_helper'

require './app/business/price_modificator'

module Payment
  MINIMUM_VALUE = 5
end

describe PriceModificator do
  let(:cart) {
    stub(:cart,
         :line_items => [ stub(:item, :total_price => 10), stub(:item, :total_price => 20) ],
         :credits => 100
        )
  }

  subject { PriceModificator.new(cart)}

  describe 'public interface' do
    subject { PriceModificator.new(stub)  }

    it 'should receive a parameter' do
      expect { PriceModificator.new(stub) }.to_not raise_exception
    end

    it 'should respond_to discounts' do
      subject.should respond_to(:discounts)
    end

    it 'should respond_to increments' do
      subject.should respond_to(:increments)
    end

    it 'should respond_to original_price' do
      subject.should respond_to(:original_price)
    end

    it 'should respond_to final_price' do
      subject.should respond_to(:final_price)
    end
  end

  describe '.discounts' do
    let (:ignore_coupon) { subject.stub(:discount_from_coupon).and_return(0) }
    let (:ignore_promotion) { subject.stub(:discount_from_promotion).and_return(0) }
    let (:ignore_item_discount) { subject.stub(:discount_from_items).and_return(0) }
    let (:ignore_credits) { subject.stub(:discount_from_credits).and_return(0) }

    it 'should return the discount list' do
      subject.stub(:discount_from_promotion).and_return(10)
      subject.stub(:discount_from_coupon).and_return(20)
      subject.stub(:discount_from_items).and_return(30)
      subject.stub(:discount_from_credits).and_return(40)

      subject.discounts[:promotion][:value].should == 10
      subject.discounts[:coupon][:value].should == 20
      subject.discounts[:product_discount][:value].should == 30
      subject.discounts[:credits][:value].should == 40
    end

    context 'when the maximal discount is 20' do
      before(:each) do
        subject.stub(:max_discount).and_return(20)
      end

      it 'should limit credits based on credits based on total and discounts' do
        ignore_coupon
        ignore_promotion
        ignore_item_discount

        subject.discounts[:credits][:value].should == BigDecimal.new(20,2)
      end

      it 'should limit credits based on credits based on total and discounts' do
        ignore_promotion
        ignore_item_discount

        subject.stub(:used_coupon).and_return(stub(:coupon, :is_percentage? => false , :value => 10))
        subject.discounts[:credits][:value].should == BigDecimal.new(10,2)
      end


      it 'should limit coupon value' do
        ignore_promotion
        ignore_item_discount
        ignore_credits

        subject.stub(:used_coupon).and_return(stub(:coupon, :is_percentage? => false , :value => 100))
        subject.discounts[:coupon][:value].should == 20

        subject.stub(:used_coupon).and_return(stub(:coupon, :is_percentage? => true, :value => 100))
        subject.discounts[:coupon][:value].should == 20
      end

      it 'should apply promotion ignoring the limit' do
        ignore_coupon
        ignore_credits
        ignore_item_discount

        subject.stub(:used_promotion).and_return(stub(:promotion, :discount_value => 100))
        subject.discounts[:promotion][:value].should == 100
      end
    end
  end

  describe '.increments' do
    it 'should return the freight and the gift wrap price' do
      subject.stub_chain(:cart, :freight_price).and_return(5)
      subject.stub(:gift_price).and_return(5)
      subject.stub_chain(:cart, :gift_wrap?).and_return(true)

      subject.increments[:gift_wrap][:wrapped].should == true
      subject.increments[:gift_wrap][:value].should == BigDecimal(5,2)
      subject.increments[:freight][:value].should == BigDecimal(5,2)
    end
  end

  describe '.original_price' do
    it 'should return the sum of cart items prices' do
      subject.original_price.should == 30
    end
  end

  describe '.final_price' do
    it 'should return the price minus the discount plus the increments' do
    end
  end
end
