class ProfileBuilder

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
