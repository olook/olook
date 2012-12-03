# == Schema Information
#
# Table name: catalog_products
#
#  id                     :integer          not null, primary key
#  catalog_id             :integer
#  product_id             :integer
#  category_id            :integer
#  subcategory_name       :string(255)
#  subcategory_name_label :string(255)
#  shoe_size              :integer
#  shoe_size_label        :string(255)
#  heel                   :string(255)
#  heel_label             :string(255)
#  original_price         :decimal(10, 2)
#  retail_price           :decimal(10, 2)
#  discount_percent       :float
#  variant_id             :integer
#  inventory              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Catalog::Product < ActiveRecord::Base
  self.table_name ='catalog_products'
  
  belongs_to :catalog
  belongs_to :product, :class_name => "::Product"
  belongs_to :variant
  
  validates :product_id, :uniqueness => {:scope => [:catalog_id, :variant_id]}
end
