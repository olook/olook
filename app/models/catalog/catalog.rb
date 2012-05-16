class Catalog::Catalog < ActiveRecord::Base
  has_many :products, :class_name => "Catalog::Product", :foreign_key => "catalog_id"
  
  validates :type, :presence => true, :exclusion => ["Catalog::Catalog"]

  def subcategories(category)
    products.where(category_id: category).group(:subcategory_name).order("subcategory_name asc").map { |p| p.subcategory_name }
  end

  def shoe_sizes
    products.where(category_id: Category::SHOE).group(:shoe_size).order("shoe_size asc").map { |p| p.shoe_size }.compact
  end

  def heels
    products.where(category_id: Category::SHOE).group(:heel).order("heel asc").map { |p| [p.heel, p.heel_label] if p.heel }.compact
  end
end
