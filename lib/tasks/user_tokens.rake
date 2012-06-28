# -*- encoding: utf-8 -*-
namespace :users do

  desc "generate_token token for user based on .csv file"
  task :generate_token, [:file] => :environment do |task, args|   
      
    CSV.open( "#{Rails.root}/AUTH_TOKEN_#{args.file}", "wb" ) do |csv|

      CSV.foreach( "#{Rails.root}/#{args.file}" ) do |row|
        data = row[0].split(";")
        user = User.find( data[2] )
        user.reset_authentication_token!
        data << user.authentication_token
        csv << data

      end
  
    end

  end

  desc "generate_token token for all users"
  task :generate_all_users_token => :environment do |task, args|
    
    User.find_each( :authentication_token => nil ) do |user|
      user.reset_authentication_token!
    end

  end

end