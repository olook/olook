namespace :facebook do
  desc 'Generates the csv file with the friends birthdays'
  task :generate_friends_birthdays_csv => :environment do
    t0 = DateTime.now.to_f
    pool = FacebookDataService.pool(size: 128)
    puts "executing multithreaded tasks"


    futures = FacebookDataService.facebook_users.limit(1000).find_in_batches(:batch_size => 50) do |users| 
      pool.future(:friends_birthdays, users) 
    end
    csv_data = futures.map(&:value).inject(:|)
    puts csv_data.size

    doc = FacebookDataService.format_to_csv(csv_data)
    local_filename = "#{Rails.root}/teste.csv"
    File.open(local_filename, 'w') {|f| f.write(doc) }
    puts "#{DateTime.now.to_f - t0} seconds"

    # t0 = DateTime.now.to_f    
    # p "executing non-multithreaded tasks"
    # fb = FacebookDataService.new
    # futures = FacebookDataService.facebook_users.first(100).map {|user| fb.friends_birthdays(user) }
    # csv_data = futures.inject(:|)
    # p csv_data.size    
    # p "#{DateTime.now.to_f - t0} seconds"
  end
end