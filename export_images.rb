Rails.logger = Logger.new STDOUT
ActiveRecord::Base.logger = Logger.new STDOUT
csv = CSV.read('pictures.csv')
head = csv.shift
picture_ids = csv.map { |c| c[2] }
picture_ids = picture_ids.inject({}) { |h,i| h[i.to_i] = i; h }
CSV.open('pictures.csv', 'wb', encoding: 'iso-8859-1') do |csv|
  csv << ['ean', 'sku', 'picture_id', 'image_url', 'image_zoom_url']
  product_ids = Variant.where('inventory > 0').pluck(:product_id)
  Picture.where(product_id: product_ids).includes(:product).order(:product_id).all.each do |picture|
    next if picture_ids[picture.id]
    if picture.image.file.exists?
      csv << ['', picture.product.model_number, picture.id, "http:#{picture.image.url}", "http:#{picture.image.zoom_out.url}"]
    end
  end
end


