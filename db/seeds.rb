# -*- encoding : utf-8 -*-

Admin.delete_all
Admin.create(:email => "admin@olook.com", :password =>"123456")

Profile.delete_all

casual  = Profile.create(:name => "Casual")
sporty  = Profile.create(:name => "Sporty")
fashion = Profile.create(:name => "Fashion")

Question.delete_all
Weight.delete_all

3.times do |i|
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
