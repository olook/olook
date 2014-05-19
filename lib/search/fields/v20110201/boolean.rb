module Search
  module Fields
    module V20110201
      class Boolean < Search::V20110201::Field
        def value
          @value == '1'
        end
      end
    end
  end
end

