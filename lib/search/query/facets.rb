module Search
  module Query
    class Facets
      def self.factory(*args)
        eval("#{Search::Config.api_version_module_name}::Facets").new(*args)
      end
    end
  end
end
