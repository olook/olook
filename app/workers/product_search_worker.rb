class ProductSearchWorker

  @queue = 'low'

  def self.perform
    clean_indexed_terms
    index_products

    # no futuro, carregar isso de um arquivo
    terms_to_add = ["onça","oncinha","calça jeans",
      "plus size","calça flare", "salto alto", "vestido longo",
      "bolsa", "sapato", "grunge"]

    terms_to_add.each{|term| ProductSearch.index_term(term)}

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
      values = Product.find_by_sql("select d_sub.description as subcategory, d.description as filter_color from products p join details d on p.id = d.product_id and d.translation_token='Cor filtro' join details d_sub on p.id = d_sub.product_id and d_sub.translation_token = 'Categoria' WHERE p.price > 0 and p.is_visible = 1")

      d1 = DateTime.now.to_i
      values.each {|value| index value}
      d2 = DateTime.now.to_i
      puts "#{d2-d1} segundos"
    end

    def self.index product     
      suggestion = Suggestion.for(product)
      term = suggestion.get
      
      if term
        ProductSearch.index_term(term)
        term.split.each { |t| ProductSearch.index_term(term) }
      end
    end
end
