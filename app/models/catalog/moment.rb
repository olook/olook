class Catalog::Moment < Catalog::Catalog
  belongs_to :moment, :class_name => "Moment", :foreign_key => "association_id"

  def self.save_product product, options = {}
    options[:moments] ||= []
    moments = options.delete(:moments)
    moments.each do |moment|
      ct_product_service = CatalogProductService.new moment.catalog, product, options
      ct_product_service.save!
    end
  end
end
