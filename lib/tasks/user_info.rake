# -*- encoding: utf-8 -*-
namespace :users do
  
  desc "Update shoe size info for each user"
  task :update_shoe_size => :environment do |task, args|
    User.find_each() do |user|
      user.user_info = UserInfo.new({ 
        :shoes_size => UserInfo::SHOES_SIZE[user.survey_answers["question_57"]] 
      }) unless user.user_info.nil? && user.survey_answers.nil?
    end
  end
end