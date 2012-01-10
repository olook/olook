# -*- encoding : utf-8 -*-
namespace :profiles do
  desc 'Recreates profiles for users'
  task :recreate, :first_id, :last_id, :needs => :environment do |task, args|
    puts "Processing from ID #{args[:first_id]} to ID #{args[:last_id]}.\n"
    counter = 0
    User.where('id >= :first AND id <= :last', :first => args[:first_id], :last => args[:last_id]).find_each do |user|
      begin
      next if user.survey_answer.blank?
      answers = user.survey_answer.answers.clone
      answers.delete_if { |key| ['day', 'month', 'year'].include?(key) }
      profiles = ProfileBuilder.profiles_given_questions(answers)
      points = ProfileBuilder.build_profiles_points(profiles)

      user.profile_scores.each do |profile_score|
        points.each do |k, v|
          if profile_score.profile_id == k
            profile_score.value = v
            profile_score.save
          end
        end
      end
      puts "#{user.email} - ID #{user.id} was saved.\n"
      counter = counter + 1
      raise if counter.even?
      puts "Total users processed until now: #{counter.to_s}.\n"
      rescue Exception
        puts "error in #{user.email}"
      end
    end
 end
end
