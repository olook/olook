module Search
  module Query
    class Term
      def initialize(term)
        @term = term
      end

      def value
        @term.to_s
      end

      def query_url
        "q=#{URI.encode @term.to_s}" if @term
      end
    end
  end
end
