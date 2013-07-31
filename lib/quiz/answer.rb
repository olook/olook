module Quiz
  class Answer
    attr_accessor :id, :image, :text

    def initialize(params)
      params.each do |key, value|
        self.send("#{ key }=", value) if self.respond_to?(key.to_sym)
      end
    end

  end
end
