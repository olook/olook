# -*- encoding : utf-8 -*-
require 'json'
module Search
  module V20130101
    class Result < Search::Result

      private

      def parse_facets
        @groups = {}
        @facets.map do |group_name, buckets|
          @groups[group_name] = {}
          if buckets["buckets"]
            buckets["buckets"].each do |c|
              @groups[group_name][c["value"]] = c['count']
            end
          end
        end
      end

      def parse_products
        @products = @hits["hit"].map do |hit|
          @parser.new(hit["id"].to_i, hit["fields"])
        end

        @products.compact!
      end
    end
  end
end
