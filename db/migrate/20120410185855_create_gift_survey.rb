class CreateGiftSurvey < ActiveRecord::Migration
  def up
     SurveyBuilder.new(GIFT_SURVEY_DATA, "Gift Survey").build
  end

  def down
    Survey.find_by_name("Gift Survey").destroy
  end
end
