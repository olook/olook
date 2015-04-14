Rails.logger = Logger.new STDOUT
CSV.open('pictures.csv', 'wb', encoding: 'iso-8859-1') do |csv|
  csv << ['ean', 'sku', 'picture_id', 'image_url', 'image_zoom_url']
  product_ids = Variant.where('inventory > 0').pluck(:product_id)
  Picture.where(product_id: product_ids).includes(:product).order(:product_id).all.each do |picture|
    if picture.image.file.exists?
      csv << ['', picture.product.model_number, picture.id, "http:#{picture.image.url}", "http:#{picture.image.zoom_out.url}"]
    end
  end
end


