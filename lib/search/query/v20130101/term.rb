module Search
  module Query
    module V20130101
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
          if @term && @term.to_s != ''
            "q=#{Search::Util.encode @term.to_s}"
          else
            ["q=matchall", "q.parser=structured"]
          end
        end
      end
    end
  end
end
