# -*- encoding : utf-8 -*-
class GiftSurveyQuestions
  attr_reader :questions

  def initialize(questions)
    @questions = questions
  end

  def common_questions
    questions[0..3]
  end

  def heel_height_question
    questions[4]
  end

  def shoe_size_question
    questions[5]
  end

  def id_first_question
    questions.first.id if questions.size > 0
  end

  def heel_height_question_number
    22
  end
end
