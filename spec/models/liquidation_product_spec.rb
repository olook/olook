# == Schema Information
#
# Table name: liquidation_products
#
#  id                     :integer          not null, primary key
#  liquidation_id         :integer
#  product_id             :integer
#  category_id            :integer
#  subcategory_name       :string(255)
#  original_price         :decimal(10, 2)
#  retail_price           :decimal(10, 2)
#  discount_percent       :float
#  shoe_size              :integer
#  heel                   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  inventory              :integer
#  shoe_size_label        :string(255)
#  heel_label             :string(255)
#  subcategory_name_label :string(255)
#  variant_id             :integer
#

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
