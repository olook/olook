class ProductSearchWorker

  @queue = 'low'

  def self.perform
    clean_indexed_terms
    index_products

    mail = DevAlertMailer.notify_about_products_search_worker
    mail.deliver
  end

  private

    def self.clean_indexed_terms
      REDIS.keys do |key|
        REDIS.del key if key.start_with? (CACHE_KEYS[:product_search][:key] % '')
      end
    end

    def self.index_products
      Product.where(is_visible: true).each do |product|
        index product if product.inventory && product.price > 0
      end
    end

    def self.index product
      ProductSearch.index_term(product.formatted_name(100))
      product.name.split.each { |t| ProductSearch.index_term(t) }
    end
end
