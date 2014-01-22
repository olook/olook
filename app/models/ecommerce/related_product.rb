# -*- encoding : utf-8 -*-
class RelatedProduct < ActiveRecord::Base
  validates_presence_of :product_a_id, :product_b_id
  belongs_to :product_a, :class_name => 'Product'
  belongs_to :product_b, :class_name => 'Product'

  scope :with_products, ->(product_ids) {where(product_a_id: product_ids).includes(:product_b, :product_a => :gallery_5_pictures)}
end
