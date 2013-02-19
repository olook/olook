# -*- encoding : utf-8 -*-
class FacebookDataService

  DESTINATION_FOLDER = "/tmp/fb_csv/"
  CONSOLIDATED_FILE_FOLDER = "/tmp/fb_consolidated_file/"
  CONSOLIDATED_FILE_NAME = "consolidated.csv"

  def initialize
  end

  # Retrieves all facebook tokens present in the database
  def self.facebook_users
    User.where("facebook_token IS NOT NULL")
  end

  # Retrieves all facebook friends' birthdays of the given users
  def friends_birthdays users, date = DateTime.now
    birthdays = []
    users.each do |user|
      # puts "processing #{user.name}"
      adapter = FacebookAdapter.new(user.facebook_token)
      friends = adapter.facebook_friends_with_birthday(date.month)
      friends.each do |friend|
        birthday_arr = friend.birthday.split("/")
        friend.birthday = "#{birthday_arr[1]}/#{birthday_arr[0]}"
        friend_hash = JSON.parse(friend.to_json)["table"]
        friend_hash["picture"] = "https://graph.facebook.com/#{friend_hash['uid']}/picture"
        friend_hash["friend_email"] = user.email
        friend_hash["friend_first_name"] = user.first_name
        birthdays << friend_hash
      end
      puts "(#{user.id}) #{user.name} => success! #{friends.size} friends!"
    end

    puts "Saving file - #{users.first.id}-#{users.last.id}.csv"
    save_file(format_to_csv(birthdays), "#{users.first.id}-#{users.last.id}.csv") unless birthdays.empty?
  end

  def format_to_csv hashes
    fields = hashes.first.keys

    # mounts header
    csv_header = fields.join(',')

    csv_body = hashes.map do |entry|
      arr = []
      fields.each{|field| arr << entry[field]}
      arr.join(',')
    end

    csv_header+"\n"+(csv_body.join("\n"))
  end

  def save_file(csv, name)
    File.open("#{DESTINATION_FOLDER}#{name}", 'w') do |file|
      file.puts csv
    end
  end

  def self.clean_destination_folder
    FileUtils.rm_rf(DESTINATION_FOLDER)
    FileUtils.mkdir_p(DESTINATION_FOLDER)    
  end

  def self.clean_consolidated_file_folder
    FileUtils.rm_rf(CONSOLIDATED_FILE_FOLDER)
    FileUtils.mkdir_p(CONSOLIDATED_FILE_FOLDER)    
  end

  def self.consolidate_csv_files
    FacebookDataService.clean_consolidated_file_folder

    File.open(CONSOLIDATED_FILE_FOLDER + CONSOLIDATED_FILE_NAME, "w") do |consolidated_file|
      header = nil

      Dir.glob(DESTINATION_FOLDER + "**").each do |file_name|
        puts file_name
        file = File.open(file_name)

        if header == nil
          header = file.readline
          consolidated_file << header
        else
          file.readline
        end

        consolidated_file << file.read

      end
    end
  end

  def self.remove_non_consolidated_files
    Dir.glob(DESTINATION_FOLDER + "**").each do |file_name|
      FileUtils.rm_rf(file_name) unless file_name == DESTINATION_FOLDER+CONSOLIDATED_FILE_NAME
    end
  end

end
