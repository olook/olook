module Search
  module Query
    module V20110201
      class Facets
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
          param = ["facet=#{@facets.join(',')}"]
          @top.each do |field, top|
            param << "facet-#{field}-top-n=#{top}"
          end
          param
        end
      end
    end
  end
end
