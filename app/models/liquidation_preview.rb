class LiquidationPreview < ActiveRecord::Base
  belongs_to :product
  attr_accessible :visibility,:product_id

  def self.import_csv csv_file
    LiquidationPreview.destroy_all
    lp_array = []
    CSV.foreach(csv_file.path, headers: false){|row| lp_array << {product_id: row.first,visibility: row.last} }
    LiquidationPreview.create(lp_array)
  end

  def self.update_visibility_in_products
    Product::PRODUCT_VISIBILITY.values.each do |p|
      Product.where(id: LiquidationPreview.where(visibility: p).map(&:product_id)).update_all(visibility: p)
    end 
  end
end
