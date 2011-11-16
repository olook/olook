# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShippingCompany do
  describe 'validations' do
    it { should have_many(:freight_prices) }

    it { should validate_presence_of(:name) }
  end
  
  describe '#find_freight_for_zip' do
    subject { FactoryGirl.create :shipping_company }
    let!(:right_freight) { FactoryGirl.create :freight_price, :shipping_company => subject,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :price => 10.0, :cost => 5.0, :delivery_time => 2 }
    let!(:wrong_freight) { FactoryGirl.create :freight_price, :shipping_company => subject,
                              :zip_start => 5379000, :zip_end => 5379015,
                              :price => 9.0, :cost => 4.0, :delivery_time => 1 }

    it 'should find a freight_price range given a zip code' do
      freight = subject.find_freight_for_zip '05379020'
      freight.should == right_freight
      freight.should_not == wrong_freight
    end
  end
end
