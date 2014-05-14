module Search
  module Query
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

      def to_param
        param = ["facet=#{@facets.join(',')}"]
        @top.each do |field, top|
          param << "facet-#{field}-top-n=#{top}"
        end
        param
      end
    end
  end
end
