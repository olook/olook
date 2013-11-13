class LiquidationPreview < ActiveRecord::Base
  belongs_to :product
  attr_accessible :category, :color, :discount_percentage, :inventory, :name, :picture_url, :price, :retail_price, :subcategory, :visibility, :visible
end
