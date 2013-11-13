class LiquidationPreview < ActiveRecord::Base
  belongs_to :product
  attr_accessible :category, :color, :discount_percentage, :inventory, :name, :picture_url, :price, :retail_price, :subcategory, :visibility, :visible

  def self.import_csv csv_file
      LiquidationProduct.destroy_all
      visibility_hash = {}
      CSV.foreach(csv.path, headers: false){|row| visibility_hash[row.first] = row.last}
      Product.where(id: visibility_hash.keys).include(:variant).each do |p|
        LiquidationProduct.create(product: p,
                                  category: p.category_humanize,
                                  color: p.product_color,
                                  discount_percentage: p.discount_percent,
                                  inventory: p.inventory,
                                  name: p.name,
                                  picture_url: p.bag_picture,
                                  price: p.price,
                                  retail_price: p.retail_price,
                                  subcategory: p.subcategory_name,
                                  visibility: visibility_hash[p.id.to_s],
                                  visible: p.is_visible)
      end
  end
end
