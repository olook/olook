module Search
  module Fields
    class Decimal < Search::Field
      def value
        normalize_decimal_numbers(@value)
      end

      def to_url
        "#{@name}:#{@value[0]}..#{@value[1]}"
      end

      def scale
        (@options[:scale] || 2).to_i
      end

      def normalize_decimal_numbers(val)
        BigDecimal.new(val.to_d/(10**scale.to_d))
      end

      def scale_decimal(val)
        val.to_d * 10 ** scale.to_d
      end
    end
  end
end

