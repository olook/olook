module Search
  module Query
    class ReturnFields
      def self.factory(*args)
        eval("#{Search::Config.api_version_module_name}::ReturnFields").new(*args)
      end
    end
  end
end
