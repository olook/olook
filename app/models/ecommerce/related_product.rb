# -*- encoding : utf-8 -*-
class RelatedProduct < ActiveRecord::Base
  validates_presence_of :product_a_id, :product_b_id
  belongs_to :product_a, :class_name => 'Product'
  belongs_to :product_b, :class_name => 'Product'
end
