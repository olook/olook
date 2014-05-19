module Search
  module Query
    module V20130101
      class Sort
        def initialize
          @rankings = {}
          @use = []
        end

        def use(*use)
          @use = use.map do |u|
            if u[0] == '-'
              "#{u[1..-1]} desc"
            else
              "#{u} asc"
            end
          end
        end

        def query_url
          param = []
          @rankings.each do |name, alg|
            param << "expr.#{name}=#{CGI.escape alg}"
          end
          param << "sort=#{@use.join(',')}"
        end

        def add_ranking(name, alg)
          @rankings[name] = alg
        end
      end
    end
  end
end
