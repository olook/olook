class Profile < ActiveRecord::Base
  has_many :answers
  has_many :points
  has_many :users, :through => :points

  def self.profiles_given_questions(questions)
    profiles = []
    questions.each do |question_name, answer_id|
      profiles << Answer.find(answer_id).profile
    end
    profiles
  end
end
