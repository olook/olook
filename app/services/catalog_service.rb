class CatalogService
  def self.save_product product, options = {}
    catalogs = Catalog::Product.where(:product_id => product.id).group(:catalog_id).map{|cp| cp.catalog}
    catalogs.each do |catalog|
      ct_product_service = CatalogProductService.new catalog, product, options
      ct_product_service.save!
    end
    
    unless options[:moments].nil?
      Catalogs::MomentStrategy.new(product, options).seek_and_destroy!
    end
  end
end
