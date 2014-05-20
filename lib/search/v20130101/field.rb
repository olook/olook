module Search
  module V20130101
    class Field < Search::Field
      def to_url
        "#{@name}:'#{@value}'"
      end
    end
  end
end
