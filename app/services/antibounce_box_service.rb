class AntibounceBoxService
	def self.generate_search(params)
		# add the parameters to meet marketing needs, that are:
		# - this search cannot include the brands inside the params
		# - half of this search products must be from olook
		antibounce_params = params.dup 
		antibounce_params["brand"] = "-#{antibounce_params['brand']}"
		search_params = SeoUrl.parse(antibounce_params)
		SearchEngine.new(search_params).with_limit(Setting.antibounce_product_lines * 3)
	end

    def self.need_antibounce_box?(search, brand)
      search.products # Calling this method in order to retrieve pages and current page
      search.pages == search.current_page && !["olook", "olook concept", "olook essential"].include?(brand.name.downcase)
    end
end