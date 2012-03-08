class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product

  delegate :name, :to => :product
  delegate :inventory, :to => :product
  delegate :color_name, :to => :product
  delegate :thumb_picture, :to => :product
  delegate :color_sample, :to => :product
end
