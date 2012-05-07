class Catalog::Catalog < ActiveRecord::Base
  has_many :products, :class_name => "Catalog::Product", :foreign_key => "catalog_id"
  
  validates :type, :presence => true, :exclusion => ["Catalog::Catalog"]
end
