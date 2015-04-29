include Rails.application.routes.url_helpers
CSV.open 'export_urls.csv', 'wb' do |csv|
  csv << ["product_number", "url"]
  Product.with_visibility(true).includes(:details).each do |product|
    csv << [product.model_number, product_seo_path(product.seo_path)]
  end
end
