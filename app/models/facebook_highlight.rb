class FacebookHighlight

	def self.products
		product_ids = MktSetting.facebook_products
		search = SearchEngine.new(product_id: product_ids).with_limit(1000)
    search.products
	end

end