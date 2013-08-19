module WhatsYourStyle
  class Question
    attr_accessor :id, :text, :answer

    def initialize(self_parameters, answers)
      self.id = self_parameters['id']
      self.text = self_parameters['text']
      @answers = []

      answers.each do |answer|
        @answers << WhatsYourStyle::Answer.new(answer)
      end
    end

    def answers
      @answers
    end
  end
end
