module Search
  module Query
    module Structured
      def self.included(base)
        base.extend(ClassMethods)
      end

      def initialize(base_class)

      end
    end
  end
end
