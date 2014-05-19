module Search
  module Query
    class Structured
      def self.factory
        eval("#{Search::Config.api_version_module_name}::Structured")
      end
    end
  end
end
