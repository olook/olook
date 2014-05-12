module Search
  module Query
    class Structured
      def initialize(base_class)
        @base = base_class
        @nodes = []
      end

      def field(key, value, options={})
        node = @base.field(key.to_s, options) || Field.new(key, @base, options)
        node.value = value
        @nodes << node
      end

      def and(&block)
        add_operator_node(:and, block)
      end

      def or(&block)
        add_operator_node(:or, block)
      end

      def not(&block)
        add_operator_node(:not, block)
      end

      def to_url
        url = @nodes.map do |node|
          node.to_url
        end
        url.join(' ')
      end

      private
      def add_operator_node(kind, block)
        child_structured = self.class.new(@base)
        block.call(child_structured)
        @nodes << Operator.new(kind, child_structured)
        self
      end
    end
  end
end
