# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductsHelper do
  with_a_logged_user do
    let!(:user_info) { FactoryGirl.create(:user_info, user: user) }
    let(:not_size_variant) { FactoryGirl.create(:basic_shoe_size_37) }
    let(:sold_out_variant) { FactoryGirl.create(:basic_shoe_size_35, :inventory => 0) }
    let(:normal_variant) { FactoryGirl.create(:basic_shoe_size_35 ) }
    let(:product) { variant.product }
    
    it "should return a string with class unavailable" do
      helper.variant_classes( sold_out_variant ).should == "unavailable"
    end

    it "should return a string with selected class" do
      helper.variant_classes( normal_variant ).should == "selected"
    end

    it "should return a empty string" do
      helper.variant_classes( not_size_variant ).should == ""
    end

    it "should return a string with selected class when force size is zero" do
      helper.variant_classes( normal_variant, 0 ).should == "selected"
    end

    it "should return a empty string when force size is zero" do
      helper.variant_classes( not_size_variant, 0 ).should == ""
    end
    
    it "should return a string with selected class when force size" do
      helper.variant_classes( not_size_variant, 37 ).should == "selected"
    end

    it "should return a empty string when force size" do
      helper.variant_classes( normal_variant, 37 ).should == ""
    end
    
  end
end
