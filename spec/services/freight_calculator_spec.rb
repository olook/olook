# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreightCalculator do
  context "when receive invalid zip code" do
    it "return empty hash" do
      expect(described_class.freight_for_zip('12', '59.9')).to eql({})
    end
    context "when receive a valid zip code" do
      context "but dont find shippings" do
        it "return default freight" do
          expect(described_class.freight_for_zip('08730-810', '59.9')).to eql(FreightCalculator::DEFAULT_FREIGHT)
        end
      end
      context "When find shippings" do
        before do
          @shipping = FactoryGirl.build(:shipping)
          @policy = FactoryGirl.build(:shipping_policy)
          Shipping.should_receive(:with_zip).with('08730810').and_return([@shipping])
          ShippingPolicy.should_receive(:with_zip).with('08730810').and_return([@policy])
        end
        it "return cheaper shipping" do
          ship = {default_shipping: { price: '15.99'.to_d, cost: '0.00'.to_d, :delivery_time=>5, :shipping_service_id=>@shipping.shipping_service_id}}
          expect(described_class.freight_for_zip('08730-810', '159.9'.to_d)).to eql(ship)
        end
      end
    end
  end
end
