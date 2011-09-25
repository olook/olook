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

  def self.build_profiles_points(profiles)
    profile_points = Hash.new
  	profiles.each do |profile|
      profile_points[profile.id] = (profile_points[profile.id].nil?) ? 1 : profile_points[profile.id] + 1 
    end
    profile_points
  end
end
