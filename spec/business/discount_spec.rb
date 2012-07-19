require 'lightweight_spec_helper'
require './app/business/discount'
describe Discount do
  let(:item) { stub(:item, :original_price => BigDecimal.new(100,2)) }

  describe '#initialize' do
    it 'should set the item value if passing a percentage' do
      described_class.new(:item => item , :percentage => 30).value.should == 70
    end

    it 'should set the percentage if passing the value' do
      described_class.new(:item => item , :value => 70).percentage.should == 30
    end

    it 'should set value and percentage to 0 if nil is passed' do
      described_class.new(:item => item).percentage.should == 0
      described_class.new(:item => item).value.should == 0
    end
  end
end
