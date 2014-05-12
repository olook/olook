module Search
  module Fields
    class Decimal < Search::Field
      def value
        normalize_decimal_numbers(@value, @options[:scale])
      end

      def to_url
      end

      def scale
        @options[:scale]
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

