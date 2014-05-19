module Search
  module Fields
    module V20110201
      class Decimal < Search::V20110201::Field
        def value
          if @options[:array]
            if @value.is_a?(Array)
              @value.map do |v|
                normalize_decimal_numbers(v)
              end
            else
              normalize_decimal_numbers(@value)
            end
          else
            normalize_decimal_numbers(@value.is_a?(Array) ? @value[0] : val)
          end
        end

        def to_url
          "#{@name}:#{scale_decimal(@value[0])}..#{scale_decimal(@value[1])}"
        end

        def scale
          (@options[:scale] || 2).to_i
        end

        def normalize_decimal_numbers(val)
          BigDecimal.new(val.to_d/(10**scale.to_d))
        end

        def scale_decimal(val)
          ( val.to_d * 10 ** scale.to_d ).to_i
        end
      end
    end
  end
end

