def answer_survey
  answer1 = Factory.create(:answer_from_casual_profile)
  answer2 = Factory.create(:answer_from_casual_profile)
  answer3 = Factory.create(:answer_from_casual_profile)
  question = answer1.question
  visit root_path
  click_link "Take the Style Quiz"
  choose "questions[question_#{question.id}]" 
  click_button "Enviar"
end