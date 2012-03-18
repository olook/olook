class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product
  belongs_to :variant

  delegate :name, :to => :product
  delegate :color_name, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :color_sample, :to => :product
  
  after_update :update_liquidation_resume
  
  private
  
  def update_liquidation_resume
    LiquidationService.new(self.liquidation).update_resume
  end
end
