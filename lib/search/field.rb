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

    def self.factory_for_type(kind, name, base_class, options={})
      case kind
      when :uint
        Search::Fields::Uint.factory.new(name, base_class, options)
      when :boolean
        Search::Fields::Boolean.factory.new(name, base_class, options)
      when :decimal
        Search::Fields::Decimal.factory.new(name, base_class, options)
      else
        self.new(name, base_class, options)
      end
    end
  end
end
