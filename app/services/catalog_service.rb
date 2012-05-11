class CatalogService
  def self.save_product product, options = {}
    Catalogs::MomentStrategy.new(product, options).seek_and_destroy!
  end
end
