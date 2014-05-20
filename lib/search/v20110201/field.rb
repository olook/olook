module Search
  module V20110201
    class Field < Search::Field
      def to_url
        "(field #{@name} '#{@value}')"
      end
    end
  end
end
