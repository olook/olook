class FacebookHighlight
	MAX_SIZE = 2

	def self.products
		product_ids = MktSetting.facebook_products
		search = SearchEngine.new(product_id: product_ids).with_limit(MAX_SIZE).products
	end

end