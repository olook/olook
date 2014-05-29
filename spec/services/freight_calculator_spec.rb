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
    end
  end
end
