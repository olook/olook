# == Schema Information
#
# Table name: liquidations
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  teaser          :string(255)
#  starts_at       :datetime
#  ends_at         :datetime
#  welcome_banner  :string(255)
#  lightbox_banner :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  resume          :text
#  teaser_banner   :string(255)
#  visible         :boolean          default(TRUE)
#  show_advertise  :boolean          default(TRUE)
#  big_banner      :string(255)
#

require 'spec_helper'

describe Liquidation do
  
  before :each do
    Liquidation.delete_all
    LiquidationProduct.delete_all
    Collection.delete_all
  end
  
  describe "validation" do
    it { should have_many(:liquidation_products) }
    it { should have_many(:liquidation_carousels) }
    it { should validate_presence_of(:name) }
  end

  it "should not update the liquidation if the change on the period conflicts with existing products" do
    FactoryGirl.create(:january_2012_collection)
    FactoryGirl.create(:march_2012_collection)  
    february_collection = FactoryGirl.create(:february_2012_collection)  
  	liquidation = FactoryGirl.create(:liquidation, :starts_at => "07/03/2012", :ends_at => "14/03/2012")
  	product = FactoryGirl.create(:basic_shoe, :collection_id => february_collection.id)
  	liquidation.liquidation_products.create(:liquidation_id => liquidation.id, :product_id => product.id)
  	liquidation.starts_at = "01/02/2012"
  	liquidation.save.should be_false
 	  liquidation.should have(1).error_on(:starts_at)
  end
end
