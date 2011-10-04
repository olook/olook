Profile.delete_all

casual  = Profile.create(:name => "Casual")
sporty  = Profile.create(:name => "Sporty")
fashion = Profile.create(:name => "Fashion")

Question.delete_all

3.times do |i|
  question = Question.create(:title => "Question #{i}")
  question.answers.create(:title => "Answer Casual from Question #{i}", :profile => casual)
  question.answers.create(:title => "Answer Sporty from Question #{i}", :profile => sporty)
  question.answers.create(:title => "Answer Fashion from Question #{i}", :profile => fashion)
end
