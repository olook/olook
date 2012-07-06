require 'lightweight_spec_helper'

require './app/business/price_modificator'

describe PriceModificator do
  let(:cart) {
    stub(:cart, :line_items => [
      stub(:item, :total_price => 10),
      stub(:item, :total_price => 20)
  ])
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
    it 'should return the discount list' do
      subject.stub(:discount_from_promotion).and_return(10)
      subject.stub(:discount_from_coupon).and_return(20)
      subject.stub(:discount_from_items).and_return(30)
      subject.stub(:credits).and_return(40)

      subject.discounts[:promotion][:value].should == 10
      subject.discounts[:coupon][:value].should == 20
      subject.discounts[:product_discount][:value].should == 30
      subject.discounts[:credits][:value].should == 40
    end

    it 'should limit credits based on credits based on total and discounts' do
      Payment::MINIMUM_VALUE = 5
      subject.stub(:discount_from_coupon).and_return(5)
      subject.stub(:discount_from_promotion).and_return(0)
      subject.stub(:discount_from_items).and_return(0)
      subject.stub_chain(:cart, :credits).and_return(10)
      subject.stub(:items_price).and_return(50)

      subject.discounts[:credits][:value].should == 10
    end
  end

  describe '.increments' do
  end

  describe '.original_price' do
    it 'should return the sum of cart items prices' do

      subject.original_price.should == 30
    end
  end

  describe '.final_price' do
  end
end
