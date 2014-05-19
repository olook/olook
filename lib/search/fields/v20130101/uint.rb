module Search
  module Fields
    module V20130101
      class Uint < Search::V20110201::Field
        def value
          if @value.is_a?(Array)
            @value[0].to_i
          else
            @value.to_i
          end
        end

        def value=(val)
          @value = val
        end

        def to_url
          min = @value[0]
          max = @value[1]

          "#{@name}:#{min if min}..#{max if max}"
        end
      end
    end
  end
end
