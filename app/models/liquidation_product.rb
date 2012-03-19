class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product
  belongs_to :variant

  delegate :name, :to => :product
  delegate :color_name, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :color_sample, :to => :product
  
  after_update :update_liquidation_resume
  
  def total_of_all_variants_inventory
    LiquidationProduct.where(:product_id => self.product_id, :liquidation_id => self.liquidation_id).sum(:inventory)
  end
  
  private
  
  def update_liquidation_resume
    LiquidationService.new(self.liquidation).update_resume
  end
end
