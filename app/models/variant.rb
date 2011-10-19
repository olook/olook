# -*- encoding : utf-8 -*-
class Variant < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :number, :presence => true
  validates :description, :presence => true
  validates :display_reference, :presence => true

  validates :price, :presence => true, :numericality => {:greater_than => 0}
  validates :inventory, :presence => true, :numericality => {:greater_than => 0, :only_integer => true}
  
  def sku
    "#{product.model_number}-#{number}"
  end
end
