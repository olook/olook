module Search
  class Field
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
      if(@options[:array])
        @value = val.is_a?(Array) ? val : [val]
      else
        @value = val.is_a?(Array) ? val[0] : val
      end
    end

    def value
      @value
    end

    def to_url
      if @options[:array]
        structured = Search::Query::Structured.new(@base)
        structured.or do |s|
          value.map do |v|
            s.field @name, v, array: false
          end
        end
        structured.to_url
      else
        "(field #{@name} '#{@value}')"
      end
    end

    class << self
      def factory(kind, name, base_class, options={})
        case kind
        when :uint
          Search::Fields::Uint.new(name, base_class, options)
        when :boolean
          Search::Fields::Boolean.new(name, base_class, options)
        when :decimal
          Search::Fields::Decimal.new(name, base_class, options)
        else
          self.new(name, base_class, options)
        end
      end
    end
  end
end
