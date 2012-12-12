class FreebieProduct < ActiveRecord::Base

  belongs_to :product
  belongs_to :freebie, :class_name => 'Product'

  validates :product_id, :freebie_id, :presence => true
end
