class SurveyQuestions
  attr_reader :questions

  def initialize(questions)
    @questions = questions
  end

  def common_questions
    questions[0..20]
  end

  def shoe_question
    questions[21]
  end

  def word_question
    questions[22]
  end

  def color_questions
    items = questions[23..26]
    colors = {
    "#{items[0].title}" => ['aths-special', 'straw', 'driftwood', 'nevada', 'ship-gray'],
    "#{items[1].title}" => ['vis-vis-to-tree-poppy', 'colonial-white-to-koromiko', 'alto-to-silver-chalice', 'dusty-gray-to-boulder', 'mercury-to-silver'],
    "#{items[2].title}" => ['pink-flare', 'peach-yellow', 'chalky', 'light-orchid', 'vanilla-ice'],
    "#{items[3].title}" => ['golden-bell', 'cardinal-pink', 'windsor', 'observatory', 'black']
    }
    colors
  end

  def first_color_question
    questions[23]
  end



  def shoe_size_question
    questions[27]
  end

  def dress_size_question
    questions[28]
  end

  def id_first_question
    questions.first.id if questions.size > 0
  end
end
