module Search
  module V20130101
    class Field < Search::Field
      def to_url
        "#{@name}:'#{@value}'"
      end

      def self.factory(kind, name, base_class, options={})
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
end
