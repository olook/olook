# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreightCalculator do
  describe "#freight_for_zip" do
    context 'given a valid zipcode' do
      let(:zip_code) { '05379020' }

      context "for which there isn't a freight price" do
        it "returns a array of hashs with price, delivery time and cost equal to zero" do
          freight = described_class.freight_for_zip(zip_code, 0)
          expect(freight[:default_shipping][:price]).to eql(FreightCalculator::DEFAULT_FREIGHT_PRICE)
          expect(freight[:default_shipping][:cost]).to eql(FreightCalculator::DEFAULT_FREIGHT_COST)
          expect(freight[:default_shipping][:delivery_time]).to eql(FreightCalculator::DEFAULT_INVENTORY_TIME)
          expect(freight[:default_shipping][:shipping_service_id]).to eql(FreightCalculator::DEFAULT_FREIGHT_SERVICE)
        end
      end

      context 'for which there is a freight price' do
        let(:order_value) { 70.1 }

        let(:freight_details1) { {:price => BigDecimal.new("10.0"), :cost => BigDecimal.new("5.0"), :delivery_time => 2 + FreightCalculator::DEFAULT_INVENTORY_TIME, :shipping_service_id => shipping_service1.id, shipping_service_priority: shipping_service1.priority, cost_for_free: "" } }
        let(:freight_details2) { {:price => BigDecimal.new("5.0"), :cost => BigDecimal.new("3.0"), :delivery_time => 30 + FreightCalculator::DEFAULT_INVENTORY_TIME, :shipping_service_id => shipping_service2.id, shipping_service_priority: shipping_service2.priority, cost_for_free: "" } }
        let(:shipping_service2) { FactoryGirl.create :shipping_service, :priority => 1 }
        let(:shipping_service1) { FactoryGirl.create :shipping_service, :priority => 99 }

        before :each do
          FactoryGirl.create  :freight_price, :shipping_service => shipping_service2,
                              :zip_start => 5379000, :zip_end => 5379014,
                              :order_value_start => 2.5, :order_value_end => 4.5,
                              :price => 310.0, :cost => 35.0, :delivery_time => 30

          FactoryGirl.create  :freight_price, :shipping_service => shipping_service2,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 69.00, :order_value_end => 128.00,
                              :price => 5.0, :cost => 3.0, :delivery_time => 30

          FactoryGirl.create  :freight_price, :shipping_service => shipping_service1,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 0.0, :order_value_end => 68.99,
                              :price => 7.0, :cost => 3.0, :delivery_time => 1
          FactoryGirl.create  :freight_price, :shipping_service => shipping_service1,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 69.00, :order_value_end => 128.99,
                              :price => 10.0, :cost => 5.0, :delivery_time => 2
          FactoryGirl.create  :freight_price, :shipping_service => shipping_service1,
                              :zip_start => 5379016, :zip_end => 5379100,
                              :order_value_start => 129.0, :order_value_end => 1000.0,
                              :price => 20.0, :cost => 15.0, :delivery_time => 3
        end
        context "with two shipping services" do 
          it "should return a hash with price, delivery time and cost" do
            expect(described_class.freight_for_zip(zip_code, order_value)).to eql(default_shipping: freight_details2,fast_shipping: freight_details1)
          end
        end
        context "with tree shipping services" do 
          let(:shipping_service3) { FactoryGirl.create :shipping_service, :priority => 10 }
          let(:freight_details3) { {:price => BigDecimal.new("5.0"), :cost => BigDecimal.new("3.0"), :delivery_time => 30 + FreightCalculator::DEFAULT_INVENTORY_TIME, :shipping_service_id => shipping_service3.id, shipping_service_priority: shipping_service3.priority, cost_for_free: "" } }
          before do
            FactoryGirl.create  :freight_price, :shipping_service => shipping_service3,
                                :zip_start => 5379016, :zip_end => 5379100,
                                :order_value_start => 69.00, :order_value_end => 128.00,
                                :price => 5.0, :cost => 3.0, :delivery_time => 30
          end
          it "should return a hash with price, delivery time and cost" do
            expect(described_class.freight_for_zip(zip_code, order_value)).to eql(default_shipping: freight_details2,fast_shipping: freight_details1)
          end
        end
      end
    end

    context 'given an invalid zipcode' do
      it "should return an empty hash " do
        described_class.stub(:'valid_zip?').and_return(false)
        expect(described_class.freight_for_zip('', 0)).to eql({})
      end
    end
  end

  describe '#clean_zip' do
    let(:dirty_zip) { ' 0A5 37## 9-02&0 ' }
    let(:clean_zip) { '05379020' }

    it 'should remove any non-numerical characters' do
      expect(described_class.clean_zip(dirty_zip)).to eql(clean_zip)
    end
    it 'should not mess with clean zips' do
      expect(described_class.clean_zip(clean_zip)).to eql(clean_zip)
    end
  end

  describe "#valid_zip?" do
    it 'should return true for a valid zip' do
      expect(described_class.valid_zip?('05379020')).to be_true
      expect(described_class.valid_zip?('01504001')).to be_true
    end

    context 'it should return false' do
      it "for an empty zip" do
        expect(described_class.valid_zip?('')).to be_false
      end
      it "for a zip with letters" do
        expect(described_class.valid_zip?('A')).to be_false
      end
      it "for a short zip" do
        expect(described_class.valid_zip?('123')).to be_false
      end
      it "for a long zip" do
        expect(described_class.valid_zip?('999999999')).to be_false
      end
    end
  end
end
