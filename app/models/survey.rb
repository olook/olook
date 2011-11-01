# -*- encoding : utf-8 -*-
class Survey
  attr_accessor :questions

  def initialize(questions)
    @questions = questions
  end

  def build
    questions.each do |item|
      create_questions(item)
      create_weights(item)
    end
  end

  private

  def create_questions(current_question)
    question = Question.create(:title => current_question[:question_title])
      current_question[:answers].each do |title|
        answer = question.answers.create(:title => title)
    end
  end

  def create_weights(current_weight)
    current_weight[:weights].each do |weight|
      weight.each do |answer_title, weight_profile|
        associate_weights_with_profiles(answer_title, weight_profile)
      end
    end
  end

  def associate_weights_with_profiles(answer_title, weight_profile)
    weight_profile.each do |weight_value, profile|
      answer = Answer.find_by_title(answer_title)
      profile = Profile.find_or_create_by_name_and_first_visit_banner(profile[:name], profile[:banner])
      Weight.create(:profile => profile, :answer => answer, :weight => weight_value)
    end
  end
end
