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

class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product
  belongs_to :variant

  delegate :name, :to => :product
  delegate :color_name, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :bag_picture, :to => :product
  delegate :showroom_picture, :to => :product
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
