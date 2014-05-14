module Search
  module Query
    class ReturnFields
      def initialize(*fields)
        @fields = []
        set_fields(fields)
      end

      def set_fields(*fields)
        @fields.concat(fields)
        @fields.flatten!
      end

      def query_url
        "return-fields=#{@fields.join(',')}" if @fields.size > 0
      end
    end
  end
end
