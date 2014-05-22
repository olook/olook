module Search
  module Query
    module V20130101
      class Facets
        DEFAULT_SIZE = 100
        def initialize(fields=[])
          @facets = fields
          @top = {}
        end

        def set_top_for(field, top)
          @top[field] = top
        end

        def <<(facet)
          @facets << facet
        end

        def query_url
          return if @facets.size == 0
          @facets.map do |f|
            "facet.#{f}=" +
            Search::Util.encode("{sort:'bucket'#{",size:#{@top[f] || DEFAULT_SIZE}"}}")
          end
        end
      end
    end
  end
end
