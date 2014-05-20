module Search
  class Field
    def self.factory
      eval("#{Search::Config.api_version_module_name}::Field")
    end

    attr_reader :name

    def initialize(name, base_class, options={})
      @name = name
      @value = nil
      @base = base_class
      @options = options
    end

    def set_options(options)
      @options = options
    end

    def value=(val)
      @value = val
    end

    def value
      if(@options[:array])
        @value.is_a?(Array) ? @value : [@value]
      else
        @value.is_a?(Array) ? @value[0] : @value
      end
    end
  end
end
