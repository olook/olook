module Search
  module Fields
    class Uint < Search::Field
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
