module Search
  module Query
    class Term
      def initialize(term)
        @term = term
      end

      def value
        @term.to_s
      end

      def to_param
        "q=#{URI.encode @term.to_s}"
      end
    end
  end
end
