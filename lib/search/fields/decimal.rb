module Search
  module Fields
    class Decimal
      def self.factory
        eval("Search::Fields::#{Search::Config.api_version_module_name}::Decimal")
      end
    end
  end
end

