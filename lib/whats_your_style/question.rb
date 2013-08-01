module WhatsYourStyle
  class Question
    attr_accessor :id, :text, :answer

    def initialize(answers)
      @answers = []
      answers.each do |answer|
        @answers << Answer.new(answer)
      end
    end

    def answers
      @answers
    end

  end
end
