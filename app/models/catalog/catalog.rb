class Catalog::Catalog < ActiveRecord::Base
  has_many :products, :class_name => "Catalog::Product", :foreign_key => "catalog_id"
  
  validates :type, :presence => true, :exclusion => ["Catalog::Catalog"]
  
  def in_category(category_id)
    products.where(category_id: category_id).where("inventory > 0")
  end
  
  def subcategories(category_id)
    in_category(category_id).group(:subcategory_name).order("subcategory_name asc").map { |p| p.subcategory_name }.compact
  end
  
  def shoes
    subcategories(Category::SHOE)
  end
  
  def bags
    subcategories(Category::BAG)
  end
  
  def accessories
    subcategories(Category::ACCESSORY)
  end
  
  def shoe_sizes
    in_category(Category::SHOE).group(:shoe_size).order("shoe_size asc").map { |p| p.shoe_size }.compact
  end

  def heels
    in_category(Category::SHOE).group(:heel).order("heel asc").map { |p| [p.heel, p.heel_label] if p.heel }.compact
  end
end
