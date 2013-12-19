# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CompleteLook do
  describe "#matches" do
    let(:cart) { FactoryGirl.create(:cart_with_3_items) }

    context "when cart doesn't contain the complete look" do
      context "when products don't contain related_products" do
        it "returns false" do
          subject.matches?(cart).should be_false
        end
      end
      
      context "when cart doesn't contain all the related products" do
        it "returns false" do
          product = cart.items.first.product
          cart.items.each{ |ci | product.relate_with_product(ci.product) unless product == ci.product}
          cart.items.pop
          subject.matches?(cart).should be_false
        end
      end
    end

    context "when cart contains the complete look" do
      context "when cart contains the complete look exactly" do
        it "returns true" do
          product = cart.items.first.product
          cart.items.each{ |ci | product.relate_with_product(ci.product) unless product == ci.product}
          subject.matches?(cart).should be_true 
        end
      end
      context "when cart contains more than the complete look" do
        it "returns true" do
          product = cart.items.last.product
          product.relate_with_product(cart.items.first.product)
          subject.matches?(cart).should be_true
        end
      end    

    end


  end
end
