module Search
  class Field
    def self.factory
      eval("#{Search::Config.api_version_module_name}::Field")
    end
  end
end
