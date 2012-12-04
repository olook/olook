require 'spec_helper'

describe LiquidationCarousel do
  
  describe "validation" do
    it { should belong_to(:liquidation) }
  end

end

