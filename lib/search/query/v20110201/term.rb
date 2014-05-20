module Search
  module Query
    module V20110201
      class Term
        def initialize(term=nil)
          @term = term
        end

        def value
          @term.to_s
        end

        def value=(val)
          @term = val
        end

        def query_url
          "q=#{URI.encode @term.to_s}" if @term
        end
      end
    end
  end
end
