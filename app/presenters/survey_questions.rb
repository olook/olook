class SurveyQuestions
  attr_reader :questions

  def initialize(questions)
    @questions = questions
  end

  def common_questions
    questions[0..questions.size - 6]
  end

  def shoe_question
    questions[questions.size - 5]
  end

  def word_question
    questions[questions.size - 4]
  end

  def star_questions
    questions[questions.size - 3]
  end

  def shoe_size_question
    questions[questions.size - 2]
  end

  def dress_size_question
    questions.last
  end

  def id_first_question
    questions.first.id if questions.size > 0
  end
end
