describe LiquidationFetchService do
  
  let(:liquidation) { FactoryGirl.create(:liquidation, :resume => nil)}
  
  describe "update fields" do 
    it "should update the subcategory name and label" do
      detail = FactoryGirl.create(:shoe_subcategory_name, :description => "Rasteirinhas")
      LiquidationProductService.new(liquidation, detail.product).save
      LiquidationService.new(liquidation.id).update_resume
      detail.description = "Sandalia"
      detail.save
      LiquidationFetchService.new(liquidation.reload).fetch!
      liquidation_product = LiquidationProduct.last
      liquidation_product.subcategory_name.should == "sandalia"
      liquidation_product.subcategory_name_label.should == "Sandalia"      
    end
    
    it "should update the heel and its label" do
      detail = FactoryGirl.create(:shoe_heel, :description => "2 cm")
      LiquidationProductService.new(liquidation, detail.product).save  
      LiquidationService.new(liquidation.id).update_resume
      detail.description = "10 cm"
      detail.save
      LiquidationFetchService.new(liquidation.reload).fetch!
      liquidation_product = LiquidationProduct.last  
      liquidation_product.heel.should == "10-cm"
      liquidation_product.heel_label.should == "10 cm"
    end  
    
    it "should update the resume" do
      detail = FactoryGirl.create(:shoe_subcategory_name, :description => "Rasteirinhas")
      LiquidationProductService.new(liquidation, detail.product).save
      liquidation_product = LiquidationProduct.last 
      liquidation_product.update_attribute(:inventory, 1)
      LiquidationService.new(liquidation.id).update_resume
      detail.description = "Sandalia"
      detail.save
      LiquidationFetchService.new(liquidation.reload).fetch!
      Liquidation.last.resume[:categories][1].keys.first.should == "sandalia"
    end
  end
  
end