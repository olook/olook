module Search
  module Query
    module Structured
      def self.included(base)
        base.extend(ClassMethods)
      end

      def initialize(base_class, parent_node)
        @base = base_class
        @parent_node = parent_node
        @nodes = []
      end

      def field(key, value)
        @nodes << Field.new(key, value, @base)
      end

      def and(&block)
        add_node(:and, block)
      end

      def or(&block)
        add_node(:or, block)
      end

      def not(&block)
        add_node(:not, block)
      end

      def to_url
        url = @nodes.map do |node|
          node.to_url
        end
        url.join
      end

      private
      def add_operator_node(kind, block)
        @nodes << Operator.new(kind, block.call(self.new(@base, self)))
      end
    end
  end
end
