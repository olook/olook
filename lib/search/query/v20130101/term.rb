module Search
  module Query
    module V20130101
      class Term
        def initialize(term)
          @term = term
        end

        def value
          @term.to_s
        end

        def query_url
          return nil
        end
      end
    end
  end
end
