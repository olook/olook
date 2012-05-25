# -*- encoding : utf-8 -*-
class GiftSurveyQuestions
  attr_reader :questions

  def initialize(questions)
    @questions = questions
  end

  def common_questions
    questions[0..6]
  end

  def id_first_question
    questions.first.id if questions.size > 0
  end

end
