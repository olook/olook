require 'spec_helper'

describe LiquidationProduct do

  it "should update the liquidation resume when it changes" do
    liquidation = FactoryGirl.create(:liquidation, :resume => nil)
    liquidation_product = FactoryGirl.create(:liquidation_product, :inventory => 1, :subcategory_name => "sandalia", :subcategory_name_label => "Sandalia", :liquidation => liquidation)
    LiquidationService.new(liquidation).update_resume
    liquidation.reload.resume[:categories][1]["sandalia"].should == "Sandalia"
    liquidation_product.reload.inventory = 0
    liquidation_product.save
    liquidation.reload.resume[:categories][1].should == {}
  end
end
