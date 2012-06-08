class Catalog::Product < ActiveRecord::Base
  self.table_name ='catalog_products'
  
  belongs_to :catalog
  belongs_to :product, :class_name => "::Product"
  belongs_to :variant
  
  validates :product_id, :uniqueness => {:scope => [:catalog_id, :variant_id]}
end
