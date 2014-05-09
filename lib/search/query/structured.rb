module Search
  module Query
    module Structured
      def self.included(base)
        base.extend(ClassMethods)
      end

      def initialize(base_class)
        @base = base_class
      end

      def and(filter)
        add_node(filter.map { |field, value| Node})
      end

      def or(filter)
      end
    end
  end
end
