module Search
  module Fields
    class Boolean < Search::Field
      def value
        @value == '1'
      end
    end
  end
end

