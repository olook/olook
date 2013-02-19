# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe ProductFinder do
  
  class Dummy
    include ProductFinder
  end

  subject { Dummy.new }

  # let!(:sold_out) { FactoryGirl.create(:blue_slipper,  }
  # let!(:product_b) { FactoryGirl.create(:blue_slipper, :name => 'B', :collection => collection, :profiles => [casual_profile]) }
  # let!(:product_c) { FactoryGirl.create(:blue_slipper, :name => 'C', :collection => collection, :profiles => [sporty_profile], :category => Category::BAG) }

  context "#remove_color_variations" do
  	context "without products passed" do
  		it "raises an ArgumentError" do
	      lambda{ subject.remove_color_variations }.should raise_error(ArgumentError)
	    end
  	end

  	it "adds to the list the products that aren't already displayed" do
  		pending
  	end

  	context "when a product of the same color was already displayed but was sold out and the algorithm find another color that isn't" do
  		it "replaces the sold out one by the one that's not sold out" do
  			pending
  		end
  	end
  end

end