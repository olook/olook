module Search
  module Query
    module V20110201
      class ReturnFields < Search::Query::ReturnFields
        def query_url
          "return-fields=#{@fields.join(',')}" if @fields.size > 0
        end
      end
    end
  end
end
