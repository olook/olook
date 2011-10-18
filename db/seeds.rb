# -*- encoding : utf-8 -*-
[Admin, Profile, Question, Answer, Weight].map(&:delete_all)

Admin.create(:email => "admin@olook.com", :password =>"123456")

casual  = Profile.create(:name => "Casual")
sporty  = Profile.create(:name => "Sporty")
fashion = Profile.create(:name => "Fashion")

2.times do |i|
  question = Question.create(:title => "Question #{i}")

  answer1 = question.answers.create(:title => "Answer for Casual and Sporty #{i}")
  answer2 = question.answers.create(:title => "Answer for Sporty and Fashion #{i}")
  answer3 = question.answers.create(:title => "Answer for Fashion and Casual #{i}")

  Weight.create(:profile => casual, :answer => answer1, :weight => 1)
  Weight.create(:profile => sporty, :answer => answer1, :weight => 1)

  Weight.create(:profile => sporty, :answer => answer2, :weight => 1)
  Weight.create(:profile => fashion, :answer => answer2, :weight => 1)

  Weight.create(:profile => fashion, :answer => answer3, :weight => 1)
  Weight.create(:profile => casual, :answer => answer3, :weight => 1)
end

question = Question.create(:title => "Question Checkbox")
12.times do |i|
  answer = question.answers.create(:title => "Answer Checkbox#{i}")
  Weight.create(:profile => casual, :answer => answer, :weight => 1)
end
