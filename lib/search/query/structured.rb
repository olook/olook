module Search
  module Query
    class Structured
      def self.factory(*args)
        eval("#{Search::Config.api_version_module_name}::Structured").new(*args)
      end
    end
  end
end
