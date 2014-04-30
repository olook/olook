# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShippingService do
  subject { FactoryGirl.create :shipping_service }

  describe 'validations' do
    it { should have_many(:freight_prices) }
    it { should have_many(:freights) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:erp_code) }
  end
  describe '#find_freight_for_zip' do
    let(:zip_code) { '05379020' }
    let(:order_value) { 49.0 }

    let!(:wrong_freight) { FactoryGirl.create :freight_price, :shipping_service => subject,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 0.0, :order_value_end => 48.9,
                              :price => 9.0, :cost => 4.0, :delivery_time => 1 }
    let!(:right_freight) { FactoryGirl.create :freight_price, :shipping_service => subject,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 49.0, :order_value_end => 120.0,
                              :price => 10.0, :cost => 5.0, :delivery_time => 2 }

    it 'should find a freight_price range given a zip code' do
      freight = subject.find_freight_for_zip zip_code, order_value
      freight.should == right_freight
      freight.should_not == wrong_freight
    end
    it 'should return nil if no freight_price was found' do
      freight = subject.find_freight_for_zip '', 0.0
      freight.should be_nil
    end
  end
end
