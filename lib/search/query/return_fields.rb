module Search
  module Query
    class ReturnFields
      def self.factory
        eval("Search::Query::#{Search::Config.api_version_module_name}::ReturnFields")
      end

      def initialize(*fields)
        @fields = []
        set_fields(fields)
      end

      def set_fields(*fields)
        @fields.concat(fields)
        @fields.flatten!
      end

      def query_url
        raise NotImplementedError.new("You should implement query_url in #{self.class}")
      end
    end
  end
end
