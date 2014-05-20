# -*- encoding : utf-8 -*-
require 'json'
module Search
  class Result
    def self.factory
      eval("#{Search::Config.api_version_module_name}::Result")
    end

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

      protected

      def empty_hits_result
        {"hit" => []}
      end

      def parse_facets
        raise NotImplementedError.new("You must implement parse_facets on #{self.class}")
      end

      def parse_products
        raise NotImplementedError.new("You must implement parse_products on #{self.class}")
      end
  end
end
