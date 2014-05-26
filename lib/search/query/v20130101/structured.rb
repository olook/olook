module Search
  module Query
    module V20130101
      class Structured < Search::Query::Structured
        def to_url
          if @nodes.size > 1
            "(#{@operator} #{url})"
          else
            url
          end
        end

        def query_url
          "fq=#{Search::Util.encode to_url}" if url.size > 0
        end
      end
    end
  end
end
