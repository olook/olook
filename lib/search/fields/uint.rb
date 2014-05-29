module Search
  module Fields
    class Uint
      def self.factory
        eval("Search::Fields::#{Search::Config.api_version_module_name}::Uint")
      end
    end
  end
end
