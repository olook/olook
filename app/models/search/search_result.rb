# -*- encoding : utf-8 -*-
class SearchResult

  attr_reader :products, :facets

  def initialize(response, options = {})
   @hits = JSON.parse(response.body)["hits"]
   @facets = JSON.parse(response.body)["facets"]
   parse_facets if options[:parse_facets]
   parse_products if options[:parse_products]
  end

  def found_products
    @hits["found"]
  end

  def grouped_products key
    @groups[key] if @groups
  end

  # TEMP
  def hits
    @hits
  end

  private

    def parse_facets
      @groups = {}
      @facets.map do |group_name, constraints|
        @groups[group_name] = {}
        if constraints["constraints"]
          constraints["constraints"].each do |c|
            @groups[group_name][c["value"]] = c['count']
          end
        end
      end
    end

    def parse_products
      @products = @hits["hit"].map do |hit|
        SearchedProduct.new(hit["id"].to_i, hit["data"])
      end

      @products.compact!
    end

end
