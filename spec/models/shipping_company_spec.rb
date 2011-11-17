# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShippingCompany do
  subject { FactoryGirl.create :shipping_company }

  describe 'validations' do
    it { should have_many(:freight_prices) }

    it { should validate_presence_of(:name) }

    it { should_not allow_value(0).for(:cubic_weight_factor) }
    it { should_not allow_value(-1).for(:cubic_weight_factor) }

    it { should validate_presence_of(:priority) }
    it { should_not allow_value(0).for(:priority) }
    it { should_not allow_value(-1).for(:priority) }

    it { should validate_presence_of(:erp_delivery_service) }
  end
  
  describe '#find_freight_for_zip' do
    let(:zip_code) { '05379020' }
    let(:weight) { 2.1 }
    let(:volume) { 0.019008 } # 11x54x32 cm


    let!(:wrong_freight) { FactoryGirl.create :freight_price, :shipping_company => subject,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :weight_start => 0.0, :weight_end => 2.5,
                              :price => 9.0, :cost => 4.0, :delivery_time => 1 }
    let!(:right_freight) { FactoryGirl.create :freight_price, :shipping_company => subject,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :weight_start => 2.5, :weight_end => 4.5,
                              :price => 10.0, :cost => 5.0, :delivery_time => 2 }

    it 'should find a freight_price range given a zip code' do
      freight = subject.find_freight_for_zip zip_code, weight, volume
      freight.should == right_freight
      freight.should_not == wrong_freight
    end
  end
  
  describe '#freight_weight, should return the biggest weight between the real weight and the cubic weight' do
    let(:volume) { 0.019008 } # 11x54x32 cm, cubic weight == 3,174336
    let(:cubic_weight) { volume * subject.cubic_weight_factor }

    context 'given a bigger real weight' do
      let(:weight) { 3.2 }
      it 'should return the real weight' do
        subject.freight_weight(weight, volume).should == weight
      end
    end
    context 'given a bigger cubic weight' do
      let(:weight) { 3.0 }
      it 'should return the cubic weight' do
        subject.freight_weight(weight, volume).should == cubic_weight
      end
    end
  end
  
  describe '#cubic_weight_factor' do
    subject { FactoryGirl.create :shipping_company }

    it 'should return 167 by default' do
      subject.cubic_weight_factor.should == 167
    end
  end
end
