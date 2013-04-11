 # -*- encoding : utf-8 -*-
require 'spec_helper'

describe Setting do
  
  describe "#is_range?" do

    context "value is a range (..)" do
      it "should return true" do
        Setting.is_range?("234..789").should be_true
      end
    end

    context "value is a exclusion range (...)" do
      it "should return false" do
        Setting.is_range?("1...789").should be_false
      end
    end
  end

  describe ".as_list" do
    context "when value is a comma separated list" do
      before do
        Setting[:list] = "first_value,second_value,third_value"
        @values = Setting.as_list(:list)
      end

      it "return an array with all values" do
        @values.should have(3).items
        @values[0].should == 'first_value'
        @values[1].should == 'second_value'
        @values[2].should == 'third_value'
      end     
    end

    context "when there is only one value" do
      before do
        Setting[:list] = "single_value"
        @values = Setting.as_list(:list)
      end

      it "return an array with 1 single element" do
        @values.should have(1).items
        @values[0].should == 'single_value'
      end
    end
    
    context "when there is no value" do
      before do
        # Setting[:list] = "single_value"
        @values = Setting.as_list(:list)
      end

      it "return an empty array" do
        @values.should have(0).items
      end
    end

  end

  describe "#convert_to_range" do

    context "for valid values" do

      it "should create ascendant range (1..10)" do
        Setting.convert_to_range("1..10").should == (1..10)
      end

      it "should create decrescent range (1456..54)" do
        Setting.convert_to_range("1456..54").should == (1456..54)
      end


    end

  end

end