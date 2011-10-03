def answer_survey
  begin
    question = FactoryGirl.create(:question)
  end until question.id.even? #cheating to make choose method work

  answer1 = FactoryGirl.create(:answer_from_casual_profile, :question => question)
  answer2 = FactoryGirl.create(:answer_from_casual_profile, :question => question)
  answer3 = FactoryGirl.create(:answer_from_casual_profile, :question => question)
  visit root_path
  click_link "Take the Style Quiz"
  choose "questions[question_#{question.id}]" 
  click_button "Enviar"
end
