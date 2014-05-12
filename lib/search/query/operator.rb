module Search
  module Query
    class Operator
      def initialize(operator, node)
        @operator = operator
        @node = node
      end

      def to_url
        "(#{@operator} #{@node.to_url})"
      end
    end
  end
end
