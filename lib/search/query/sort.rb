module Search
  module Query
    class Sort
      def self.factory
        eval("Search::Query::#{Search::Config.api_version_module_name}::Sort")
      end
    end
  end
end

