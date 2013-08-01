module Quiz
  class Question
    attr_accessor :id, :text, :answer

    def initialize(answers)
      @answers = []
      answers.each do
        Answer.new()
      end
    end

  end
end
