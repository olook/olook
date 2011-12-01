require 'benchmark'

namespace :olook do
  desc "Recreate profiles for user"
  task :recreate_user_profile, :user_count, :needs => :environment do |t, args|
    benchmark = Benchmark.measure do
      limit = args[:user_count].to_i
      User.find_each(:batch_size => 50) do |user|
        next if user.survey_answer.blank?
        next unless user.points.empty?

        user_answers = user.survey_answer.answers.clone
        user_answers.delete_if {|key, value| ['day', 'month', 'year'].include?(key)}

        profiles_for_questions = ProfileBuilder.profiles_given_questions(user_answers)
        profile_points = ProfileBuilder.build_profiles_points(profiles_for_questions)
        profile_builder = ProfileBuilder.new user
        User.transaction do
          profile_builder.create_user_points profile_points
          puts "Processed #{user.email}"
        end
        break if (limit -= 1) == 0
      end
    end
    puts "Benchmark: #{benchmark}"
  end

  desc "Load and reprocess new weights for the survey"
  task :change_weights, :filename, :needs => :environment do |t, args|
    filename = args[:filename]
    unless File.exists? filename
      puts "File #{filename} doesn't exist"
      next
    end

    line_number = 0
    results = []
    profiles = []
    CSV.read(filename).each do |line|
      line_number += 1
      
      if line_number == 1
        profiles = line.clone
        (4..10).each do |column|
          profiles[column] = profiles[column].match(/(\d{2}) - .*/)[1].to_i
        end
      else
        (4..10).each do |column|
          unless line[column].nil?
            weight = line[column].to_i
            answer = line[2].to_i
            profile = profiles[column]
            results << {:answer_id => answer, :profile_id => profile, :weight => weight}
          end
        end
      end
    end

    puts '----------'
    puts profiles
    puts '----------'
    puts results
    puts '----------'
    
    if results.length > 0
      Weight.transaction do
        Weight.delete_all
        results.each {|result| Weight.create result}
      end
    end
  end
end
