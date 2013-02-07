# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MomentsHelper do

  describe "#installments" do
    context "when price is 83,56" do   
      it "return '2 x de R$ 40,00'" do
        helper.installments(83.56).should == '2 x de R$ 41,78'
      end
    end

    context "when price is 23,53" do   
      it "return '1 x de R$ 23,53'" do
        helper.installments(23.53).should == '1 x de R$ 23,53'
      end
    end

    context "when price is 400" do   
      it "return '10 x de R$ 40,00'" do
        helper.installments(400).should == '10 x de R$ 40,00'
      end
    end
  end

end