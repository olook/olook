# -*- encoding : utf-8 -*-
class RecreateGiftSurveyQuestions < ActiveRecord::Migration
  def up
    survey = Survey.find_by_name("Gift Survey")
    survey.questions.destroy_all if survey
    SurveyBuilder.new(GIFT_SURVEY_DATA, "Gift Survey").build
  end

  def down
    Survey.find_by_name("Gift Survey").destroy
  end
end
