module Search
  module Query
    class Term
      def self.factory(*args)
        eval("#{Search::Config.api_version_module_name}::Term").new(*args)
      end
    end
  end
end

