# -*- encoding : utf-8 -*-
class FacebookDataService
  def self.facebook_users
    User.where("facebook_token IS NOT NULL AND facebook_permissions LIKE '%birthday%'")
  end

  def generate_csv_lines(start_date)
      csv_lines = ["email,first_name,auth_token,friend_data"]
      FacebookDataService.facebook_users.each do |user|
        user_hash = format_user_data(user, start_date) 
        csv_lines << user_hash unless user_hash.blank?
      end
      csv_lines    
  end
  private  

  def format_user_data(user, start_date)
    adapter = FacebookAdapter.new(user.facebook_token)
    friends = adapter.facebook_friends
    user_hash = {}
    user_hash["email"] = user.email
    user_hash["first_name"] = user.first_name
    user_hash["auth_token"] = user.authentication_token
    friend_data = friends.map{|friend| format_fb_friend_data(friend, start_date) }.compact
    user_hash["friend_data"] = friend_data.empty? ? "" : friend_data.join("#")
    friend_data.empty? ? nil : "#{user_hash['email']},#{user_hash['first_name']},#{user_hash['auth_token']},#{user_hash['friend_data']}" 
  end

  def format_fb_friend_data(friend, start_date)
    birthday_arr = friend.birthday.split("/")
    friend.birthday = "#{birthday_arr[1]}/#{birthday_arr[0]}"
    friend_hash = JSON.parse(friend.to_json)["table"]
    friend_hash["picture"] = "https://graph.facebook.com/#{friend_hash['uid']}/picture"
    add_friend_to_list?(friend_start_date) ? "#{friend_hash['first_name']}|#{friend_hash['picture']}|#{friend_hash['birthday']}" : nil
  end

  def add_friend_to_list?(friend, start_date)
    (start_date + 15.days) >= Date.strptime(friend.birthday, "%m/%d")
  end
end
