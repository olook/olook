module Search
  module Query
    class Sort
      def initialize
        @rankings = {}
        @use = []
      end

      def use(*use)
        @use=use
      end

      def query_url
        param = []
        @rankings.each do |name, alg|
          param << "rank-#{name}=#{CGI.escape alg}"
        end
        param << "rank=#{@use.join(',')}"
      end

      def add_ranking(name, alg)
        @rankings[name] = alg
      end
    end
  end
end
