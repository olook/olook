# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  has_enumeration_for :category, :with => Category, :required => true
  
  has_many :pictures, :dependent => :destroy
  has_many :details, :dependent => :destroy
  has_many :variants, :dependent => :destroy

  validates :name, :presence => true
  validates :description, :presence => true
  validates :model_number, :presence => true
  
  scope :shoes , where(:category => Category::SHOE)
  scope :bags  , where(:category => Category::BAG)
  scope :jewels, where(:category => Category::JEWEL)

  def related_products
    products_a = RelatedProduct.select(:product_a_id).where(:product_b_id => self.id).map(&:product_a_id)
    products_b = RelatedProduct.select(:product_b_id).where(:product_a_id => self.id).map(&:product_b_id)
    Product.where(:id => (products_a + products_b))
  end
  
  def is_related_to?(other_product)
    related_products.include? other_product
  end
  
  def relate_with_product(other_product)
    if is_related_to?(other_product)
      other_product
    else
      RelatedProduct.create(:product_a => self, :product_b => other_product)
    end
  end
end
