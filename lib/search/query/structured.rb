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
        Field.new(key, value, @base)
      end

      def and(&block)
      end

      def or(&block)
      end

      def not(&block)
      end
    end
  end
end
