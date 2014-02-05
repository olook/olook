class LiquidationPreview < ActiveRecord::Base
  belongs_to :product
  attr_accessible :visibility,:product_id

  def self.import_csv csv_file
    LiquidationPreview.delete_all
    lp_array = []
    now = Time.zone.now.utc.iso8601.gsub(/T/, ' ').gsub('Z', '')
    CSV.foreach(csv_file.path, headers: false){|row| lp_array << ( "('%s', %d, '%s', %d)" % [now, row.first, now, row.last] ) rescue nil }
    query = "INSERT INTO `#{LiquidationPreview.table_name}` (`created_at`, `product_id`, `updated_at`, `visibility`) VALUES "
    values = lp_array.shift(1000)
    while values.size > 0 do
      LiquidationPreview.connection.insert(query + values.join(','))
      values = lp_array.shift(1000)
    end
  end

  def self.update_visibility_in_products
    Product::PRODUCT_VISIBILITY.values.each do |p|
      Product.where(id: LiquidationPreview.where(visibility: p).map(&:product_id)).update_all(visibility: p)
    end 
  end
end
