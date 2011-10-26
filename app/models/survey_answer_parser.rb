class SurveyAnswerParser
  attr_reader :answers

  def initialize(answers)
    @answers = answers
  end

  def build_survey_answers
    parsed_questions = parse()
    selected_questions = Question.find(get_questions_ids)
    selected_answers = Answer.find(get_answers_ids)
    questions_answers = []
    parsed_questions.each do |item|
      q = find_question(selected_questions, item)
      a = find_answer(selected_answers, item)
      questions_answers << {:question => q, :answer => a}
    end
    questions_answers
  end

  def parse
    parsed_questions = []
    answers.each do |question, answer|
      unless birthday_question?(question)
        question = question.to_s.scan(/[0-9]+/).first
        parsed_questions << {question => answer}
      end
    end
    parsed_questions.compact
  end

  def get_questions_ids
    questions_ids = []
    answers.each do |question, answer|
      unless birthday_question?(question)
        question = question.to_s.scan(/[0-9]+/).first
        questions_ids << question
      end
    end
    questions_ids.compact
  end

  def get_answers_ids
    answers_ids = []
    answers.each do |question, answer|
      unless birthday_question?(question)
        answers_ids << answer
      end
    end
    answers_ids
  end

  private

  def birthday_question?(question)
    (question == "day" || question == "month" || question == "year")
  end

  def find_question(questions, item)
    questions.select{|q| q.id == item.keys[0].to_i}.first
  end

  def find_answer(answers, item)
    answers.select{|a| a.id == item.values[0].to_i}.first
  end
end
