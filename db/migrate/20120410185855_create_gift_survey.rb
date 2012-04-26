# -*- encoding : utf-8 -*-
class CreateGiftSurvey < ActiveRecord::Migration
  def up
  	 # destroy all answers without associated questions
  	 Answer.all.each { |a| a.destroy  unless a.question }
     SurveyBuilder.new(GIFT_SURVEY_DATA, "Gift Survey").build
  end

  def down
    Survey.find_by_name("Gift Survey").destroy
  end
end
