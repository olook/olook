require 'spec_helper'

describe PromotionAction do

  describe "#apply" do
    it { should respond_to(:apply).with(2).arguments }
  end

  describe "#calculate" do
    it { should respond_to(:calculate).with(2).arguments }
  end

end
