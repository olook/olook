namespace :olook do
  desc "Recreate profiles for user"
  task :recreate_user_profile_1, :user_count, :needs => :environment do |t, args|
    limit = args[:user_count].to_i
    puts "Processando"
    puts limit
    count = 0
    User.where('id >= 0 AND id <= 80000').each do |user|
      next if user.survey_answer.blank?
      user_answers = user.survey_answer.answers.clone
      user_answers.delete_if {|key, value| ['day', 'month', 'year'].include?(key)}
      profiles_for_questions = ProfileBuilder.profiles_given_questions(user_answers)
      profile_points = ProfileBuilder.build_profiles_points(profiles_for_questions)
      user.profile_scores.each do |user_profile_point|		
        profile_points.each do |profile,point|
          if user_profile_point.profile_id == profile
  	    user_profile_point.value = point
  	    user_profile_point.save
  	  end
        end
      end
      puts user.email + " saved"
      count = count + 1
      puts "Users processed:" + count.to_s
    end
  end
end
