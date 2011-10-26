class QuestionParser
  attr_reader :questions

  def initialize(questions)
    @questions = questions
  end

  def parse
    parsed_questions = []
    questions.each do |question, answer|
      question = question.to_s.scan(/[0-9]+/).first
      parsed_questions << {question => answer}
    end
    parsed_questions
  end

  def get_questions_ids
    questions_ids = []
    questions.each do |question, answer|
      question = question.to_s.scan(/[0-9]+/).first
      questions_ids << question
    end
    questions_ids
  end

  def get_answers_ids
    answers_ids = []
    questions.each do |question, answer|
      answers_ids << answer
    end
    answers_ids
  end
end
