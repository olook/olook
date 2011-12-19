# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CreditCardsHelper do
  it "should return an array with the select options" do
    expected = [["1x de R$ 113,47 sem juros", 1],["2x de R$ 56,74 sem juros", 2], ["3x de R$ 37,82 sem juros", 3]]
    helper.build_installment_options(113.47, 3).should == expected
  end
end


