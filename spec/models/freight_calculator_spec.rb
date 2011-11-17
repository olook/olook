# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreightCalculator do
  describe "#freight_for_zip" do
    context 'given a valid zipcode' do
      let(:zip_code) { '05379020' }

      context "for which there isn't a freight price" do
        it "should return a hash with price, delivery time and cost equal to zero" do
          freight = described_class.freight_for_zip(zip_code, 0, 0)
          freight[:price].should == 0.0
          freight[:cost].should == 0.0
          freight[:delivery_time].should == 0
        end
      end

      context 'for which there is a freight price' do
        let(:weight) { 2.1 }
        let(:volume) { 0.019008 } # 11x54x32 cm, cubic weight == 3,174336

        let(:freight_details) { {:price => 10.0, :cost => 5.0, :delivery_time => 2} }
        let(:wrong_shipping_company) { FactoryGirl.create :shipping_company, :priority => 1 }
        let(:shipping_company) { FactoryGirl.create :shipping_company, :priority => 99 }
        
        before :each do
          FactoryGirl.create  :freight_price, :shipping_company => wrong_shipping_company,
                              :zip_start => 5379000, :zip_end => 5379014,
                              :weight_start => 2.5, :weight_end => 4.5,
                              :price => 310.0, :cost => 35.0, :delivery_time => 30

          FactoryGirl.create  :freight_price, :shipping_company => shipping_company,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :weight_start => 0.0, :weight_end => 2.5,
                              :price => 7.0, :cost => 3.0, :delivery_time => 1
          FactoryGirl.create  :freight_price, :shipping_company => shipping_company,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :weight_start => 2.5, :weight_end => 4.5,
                              :price => 10.0, :cost => 5.0, :delivery_time => 2
          FactoryGirl.create  :freight_price, :shipping_company => shipping_company,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :weight_start => 4.5, :weight_end => 1000.0,
                              :price => 20.0, :cost => 15.0, :delivery_time => 3
        end
        
        it "should return a hash with price, delivery time and cost" do
          described_class.freight_for_zip(zip_code, weight, volume).should == freight_details
        end
      end
    end

    context 'given an invalid zipcode' do
      it "should return an empty hash " do
        described_class.stub(:'valid_zip?').and_return(false)
        described_class.freight_for_zip('', 0, 0).should == {}
      end
    end
  end

  describe '#clean_zip' do
    let(:dirty_zip) { ' 0A5 37## 9-02&0 ' }
    let(:clean_zip) { '05379020' }

    it 'should remove any non-numerical characters' do
      described_class.clean_zip(dirty_zip).should == clean_zip
    end
    it 'should not mess with clean zips' do
      described_class.clean_zip(clean_zip).should == clean_zip
    end
  end

  describe "#valid_zip?" do
    it 'should return true for a valid zip' do
      described_class.valid_zip?('05379020').should be_true
      described_class.valid_zip?('01504001').should be_true
    end

    context 'it should return false' do
      it "for an empty zip" do
        described_class.valid_zip?('').should be_false
      end
      it "for a zip with letters" do
        described_class.valid_zip?('A').should be_false
      end
      it "for a short zip" do
        described_class.valid_zip?('123').should be_false
      end
      it "for a long zip" do
        described_class.valid_zip?('999999999').should be_false
      end
    end
  end
end
