# -*- encoding : utf-8 -*-
class ProfileBuilder

  attr_accessor :user

  def initialize(user)
   @user = user
  end

  def create_user_points(session)
    user_dont_have_points = user.points.size == 0
    if user_dont_have_points
      session.each do |profile_id, points|
        user.points.create(:value => points, :profile_id => profile_id)
      end
    end
  end

  def self.profiles_given_questions(questions)
    profiles = []
    questions.each do |question_name, answer_id|
      Answer.find(answer_id).profiles.each do |profile|
        profiles << {:profile => profile, :weight => Weight.where(:profile_id => profile.id, :answer_id => answer_id).first.weight}
      end
    end
    profiles
  end

  def self.build_profiles_points(profiles)
    profile_points = Hash.new
    profiles.each do |profile|
      weight = profile[:weight]
      profile_points[profile[:profile].id] = (profile_points[profile[:profile].id].nil?) ? weight : profile_points[profile[:profile].id] + weight
    end
    profile_points
  end

end
