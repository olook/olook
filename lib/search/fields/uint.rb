module Search
  module Fields
    class Uint < Search::Field
      def value
        @value.to_i
      end
    end
  end
end
