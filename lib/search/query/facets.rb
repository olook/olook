module Search
  module Query
    class Facets
      def self.factory
        eval("#{Search::Config.api_version_module_name}::Facets")
      end
    end
  end
end
