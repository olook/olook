# -*- encoding : utf-8 -*-
class FacebookDataService

  def generate_facebook_friends_birthdays_csv_list
    #fb_tokens = facebook_tokens
    birthdays = friends_birthdays(facebook_users)
    format_to_csv(birthdays)
  end

  private
  # Retrieves all facebook tokens present in the database
  def facebook_users
    User.where("facebook_token IS NOT NULL")
  end

  # Retrieves all facebook friends' birthdays of the given users
  def friends_birthdays users    
    birthdays = []
    users.find_each do |user|
      puts user.facebook_token
      begin
        friends = FacebookAdapter.new(user.facebook_token).facebook_friends_with_birthday(DateTime.now.month)
        friends.each do |friend|
          birthday_arr = friend.birthday.split("/")
          friend.birthday = "#{birthday_arr[1]}/#{birthday_arr[0]}"
          friend_hash = JSON.parse(friend.to_json)["table"]
          friend_hash["friend_email"] = user.email
          birthdays << friend_hash
        end
      rescue Koala::Facebook::APIError
        p "expired token!"
      end
    end
    birthdays
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

end