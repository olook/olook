namespace :facebook do
  desc 'Generates the csv file with the friends birthdays'
  task :generate_friends_birthdays_csv => :environment do
    t0 = DateTime.now.to_f
    pool = FacebookDataService.pool(size: 2)
    puts "executing multithreaded tasks"
    fbds = FacebookDataService.new
    starting_point = ENV['STARTING_POINT']? ENV['STARTING_POINT']:0

    FacebookDataService.clean_destination_folder

    batches = []
    puts "finding users with facebook authentication token"
    FacebookDataService.facebook_users.where("id > #{starting_point}").find_in_batches(:batch_size => 50){|users| batches << users}
    # ok so far 

    
    batches.each do |users|
      puts "processing" 
      pool.friends_birthdays(users)
    end

    # puts "creating csv file"
    # csv_data = futures.map(&:value).inject(:|)
    # puts csv_data.size

    # doc = FacebookDataService.format_to_csv(csv_data)
    # local_filename = "#{Rails.root}/teste.csv"
    # File.open(local_filename, 'w') {|f| f.write(doc) }
    # puts "#{DateTime.now.to_f - t0} seconds"

  end
end