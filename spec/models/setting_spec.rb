# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
