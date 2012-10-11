namespace :facebook do
  desc 'Generates the csv file with the friends birthdays'
  task :generate_friends_birthdays_csv => :environment do
    pool = FacebookDataService.pool(size: 2)
    puts "executing multithreaded tasks"
    fbds = FacebookDataService.new
    starting_point = ENV['STARTING_POINT']? ENV['STARTING_POINT']:0

    FacebookDataService.clean_destination_folder
    date = DateTime.now # change it if you want to setup a custom date

    batches = []
    puts "finding users with facebook authentication token"
    FacebookDataService.facebook_users.where("id > #{starting_point}").find_in_batches(:batch_size => 50){|users| batches << users}
    # ok so far 
    
    batches.each do |users|
      puts "processing" 
      pool.friends_birthdays(users, date)
    end

    puts "consolidating csv files"
    FacebookDataService.consolidate_csv_files
  end

  desc 'Consolidate all the csv files'
  task :consolidate_csv_files => :environment do
    FacebookDataService.consolidate_csv_files
  end

end