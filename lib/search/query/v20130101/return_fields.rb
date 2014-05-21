module Search
  module Query
    module V20130101
      class ReturnFields < Search::Query::ReturnFields
        def query_url
          "return=#{@fields.join(',')}" if @fields.size > 0
        end
      end
    end
  end
end
