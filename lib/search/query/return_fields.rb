module Search
  module Query
    class ReturnFields
      def self.factory
        eval("#{Search::Config.api_version_module_name}::ReturnFields")
      end
    end
  end
end
