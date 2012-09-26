namespace :facebook
  desc 'Generates the csv file with the friends birthdays'
  task :generate_friends_birthdays_csv => :environment do
    fb = FacebookDataService.new
    puts fb.generate_facebook_friends_birthdays_csv_list
  end
end