module Search
  module Query
    module V20110201
      class Structured < Search::Query::Structured
        def to_url
          "(#{@operator} #{url})"
        end

        def query_url
          "bq=#{CGI.escape to_url}" if url.size > 0
        end
      end
    end
  end
end
