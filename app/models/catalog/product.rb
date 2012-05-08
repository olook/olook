class Catalog::Product < ActiveRecord::Base
  self.table_name ='catalog_products'
  
  belongs_to :catalog
  belongs_to :product
  belongs_to :variant
  
  validates :catalog_id, :uniqueness => {:scope => [:product_id, :variant_id]}
  
end
