def answer_survey(question)
  visit root_path
  click_link "Take the Style Quiz"
  choose "questions[question_#{question.id}]" 
  click_button "Enviar"
end