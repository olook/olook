# -*- encoding: utf-8 -*-
namespace :users do
  desc "Send in the card email"
  task :generate_token => :environment do |task, args|
    files = [
              "Seg_Users_01dezA31dez_semhotmail.csv",
              "Seg_Users_01dezA31dez_sohotmail.csv",
              "Seg_Users_01janA18fev_semhotmail.csv",
              "Seg_Users_01janA18fev_sohotmail.csv",
              "Seg_Users_01novA30nov_semhotmail.csv",
              "Seg_Users_01novA30nov_sohotmail.csv"
            ]
    files.each do |file|
      CSV.open( "#{Rails.root}/AUTH_TOKEN_#{file}", "wb" ) do |csv|
        CSV.foreach( "#{Rails.root}/#{file}" ) do |row|
          data = row[0].split(";")
          user = User.find_by_email( data[1] )
          user.reset_authentication_token!
          data << user.authentication_token
          csv << data
        end
      end
    end
  end
end