require 'benchmark'
require 'ruby-debug'
namespace :olook do
  desc "Recreate profiles for user"
  task :recreate_user_profile_1, :user_count, :needs => :environment do |t, args|
   # benchmark = Benchmark.measure do
      limit = args[:user_count].to_i
		#	puts "Processando"
		#	puts limit
      User.find_each(:batch_size => 100) do |user|
				#User.where('id >= 271208').each do |user|
			#	ap user.first_name
			#	ap user.survey_answer.to_s
        next if user.survey_answer.blank?
    		next unless user.points.empty?
			#	puts user.first_name
        user_answers = user.survey_answer.answers.clone
        user_answers.delete_if {|key, value| ['day', 'month', 'year'].include?(key)}
        profiles_for_questions = ProfileBuilder.profiles_given_questions(user_answers)
        profile_points = ProfileBuilder.build_profiles_points(profiles_for_questions)
			#	debugger
       # profile_builder = ProfileBuilder.new user
				user.profile_scores.each do |user_profile_point|		
						profile_points.each do |profile,point|
							if user_profile_point.profile_id == profile
								user_profile_point.value = point
								user_profile_point.save
								puts "Processed #{user.email}"
							end
						end
					user.save
				end
	
       # User.transaction do
          #profile_builder.create_user_points profile_points
					
          #puts "Processed #{user.email}"
        #end
		end
	#end
end
end
