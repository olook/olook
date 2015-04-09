CSV.open('pictures.csv', 'wb') do |csv|
  csv << ['sku', 'picture_id', 'image_url', 'image_zoom_url', 'display_on']
  Picture.includes(:product).order(:product_id).all.each do |picture|
    csv << [picture.product.model_number, picture.id, "http:#{picture.image.url}", picture.display_on_humanize]
  end
end


