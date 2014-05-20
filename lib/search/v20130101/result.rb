# -*- encoding : utf-8 -*-
require 'json'
module Search
  module V20130101
    class Result

      attr_reader :products, :facets

      def initialize(response_body, options = {})
        @hits = JSON.parse(response_body)["hits"] || empty_hits_result
        @facets = JSON.parse(response_body)["facets"] || {}
        @parser = options[:parser]
        parse_facets if options[:parse_facets]
        parse_products if options[:parse_products]
      end

      def found_products
        @hits["found"]
      end

      def grouped_products key
        @groups[key].dup if @groups && @groups[key]
      end

      # TEMP
      def hits
        @hits.dup
      end

      def set_groups(key, new_hash)
        @groups[key] = new_hash
      end

      private

      def empty_hits_result
        {"hit" => []}
      end

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
