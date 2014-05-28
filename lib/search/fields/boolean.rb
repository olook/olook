module Search
  module Fields
    class Boolean
      def self.factory
        eval("Search::Fields::#{Search::Config.api_version_module_name}::Boolean")
      end
    end
  end
end

