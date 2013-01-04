# -*- encoding : utf-8 -*-
require 'spec_helper.rb'

describe Parameters do
  class Dummy
    include Parameters
    extend Parameters::ClassMethods

  end

  context "when class does not override 'params' method" do

    it "should raise error" do
      d = Dummy.new
      lambda{ d.field_name }.should raise_error
    end

  end

  context "when class overrides 'params' method" do
    class Dummy
      attr_accessor :params

      parameter :field_name, :string
    end

    it "should return the right value" do
      d = Dummy.new
      d.params = {:field_name => {:value => "field_value"}}
      d.field_name.should eq "field_value"
    end

    context "when parameter is BigDecimal" do
      class Dummy
        parameter :field_name_decimal, :decimal
      end

      before do
        @d = Dummy.new
        @d.params = {:field_name_decimal => {:value => "80.0", :type => :decimal}}
      end

      it "should respond_to 'field_name_decimal' method" do
        @d.should respond_to :field_name_decimal
      end

      it "should respond_to 'field_name_decimal=' method" do
        @d.should respond_to :field_name_decimal
      end

      it "should return a big decimal" do
        @d.field_name_decimal.class.should eq BigDecimal
      end

      context "when changing the value of the field" do

        it "should return the updated value" do
          @d.field_name_decimal = 30.45
          @d.field_name_decimal.should eq 30.45
        end

      end


    end


  end


end