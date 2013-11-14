class LiquidationPreview < ActiveRecord::Base
  belongs_to :product
  attr_accessible :category, :color, :discount_percentage, :inventory, :name, :picture_url, :price, :retail_price, :subcategory, :visibility, :visible, :product_id, :collection

  def self.import_csv csv_file
    LiquidationPreview.destroy_all
    visibility_hash = {}
    CSV.foreach(csv_file.path, headers: false){|row| visibility_hash[row.first] = row.last}
    Product.where(id: visibility_hash.keys).includes(:variants).each do |p|
      LiquidationPreview.create(product_id: p.id,
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
                                visible: p.is_visible,
                                collection: p.collection.name)
    end
  end

  def self.update_visibility_in_products
    LiquidationPreview.all.each{|lp| lp.product.update_attribute(:visibility, lp.visibility)}
  end
end
