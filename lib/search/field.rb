module Search
  class Field
    def initialize(name, options={})
      @name = name
      @value = nil
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
      "(field #{@field} #{@value})"
    end

    class << self
      def factory(kind, name, options={})
        case kind
        when :uint
          Search::Fields::Uint.new(name, options)
        when :boolean
          Search::Fields::Boolean.new(name, options)
        when :decimal
          Search::Fields::Decimal.new(name, options)
        else
          self.new(name, options)
        end
      end
    end
  end
end
