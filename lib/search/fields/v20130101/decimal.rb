module Search
  module Fields
    module V20130101
      class Decimal < Search::V20130101::Field
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
          min = scale_decimal(@value[0])
          max = scale_decimal(@value[1])
          min = min ? "[#{min}" : '{'
          max = max ? "#{max}]" : '}'
          "#{@name}:#{},#{}"
        end

        private

        def scale
          (@options[:scale] || 2).to_i
        end

        def normalize_decimal_numbers(val)
          BigDecimal.new(val.to_d/(10**scale.to_d))
        end

        def scale_decimal(val)
          ( val.to_d * 10 ** scale.to_d ).to_i if val
        end
      end
    end
  end
end

