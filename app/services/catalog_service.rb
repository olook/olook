class CatalogService
  def self.save_product product, options = {}
    Catalog::Moment.save_product product, options
  end
end
