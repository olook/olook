module Search
  module Query
    class Sort
      def self.factory(*args)
        eval("#{Search::Config.api_version_module_name}::Sort").new(*args)
      end
    end
  end
end

