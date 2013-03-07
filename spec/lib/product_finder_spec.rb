# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe ProductFinder do
  
  class Dummy
    include ProductFinder
  end

  subject { Dummy.new }

  let!(:sold_out)  { FactoryGirl.create(:shoe, :sold_out) }
  let!(:in_stock)  { FactoryGirl.create(:shoe, :in_stock) }
  let!(:duplicate_in_stock) { FactoryGirl.create(:shoe, :in_stock) }
  let!(:products)  { [sold_out, in_stock, duplicate_in_stock] }

  context "#remove_color_variations" do
  	context "without products passed" do
  		it "raises an ArgumentError" do
	      lambda{ subject.remove_color_variations }.should raise_error(ArgumentError)
	    end
  	end

    context "when passed two or more products with the same name" do
    	it "removes repeated products" do
    		expect(subject.remove_color_variations(products)).to_not include(duplicate_in_stock)
    	end
    end

  	context "when passed a product that was already displayed and sold out" do
  		it "replaces it with another product by the same name, presumably with a different color" do
  			expect(subject.remove_color_variations(products)).to include(in_stock)
        expect(subject.remove_color_variations(products)).to_not include(sold_out)
  		end
  	end
  end

end