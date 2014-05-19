module Search
  module Query
    class Term
      def self.factory
        eval("#{Search::Config.api_version_module_name}::Term")
      end
    end
  end
end

