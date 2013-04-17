# -*- encoding : utf-8 -*-
class FacebookDataService
  def self.facebook_users
    User.where("facebook_token IS NOT NULL AND facebook_permissions LIKE '%birthday%'")
  end

  def format_user_data(user, month, middle_of_the_month)
    adapter = FacebookAdapter.new(user.facebook_token)
    friends = adapter.facebook_friends_with_birthday(month)
    user_hash = {}
    user_hash["email"] = user.email
    user_hash["first_name"] = user.first_name
    user_hash["auth_token"] = user.authentication_token
    friend_data = friends.map{|friend| format_fb_friend_data(friend, middle_of_the_month) }.compact
    user_hash["friend_data"] = friend_data.empty? ? "" : friend_data.join("#")
    friend_data.empty? ? nil : [user_hash['email'],user_hash['first_name'],user_hash['auth_token'],user_hash['friend_data']] 
  end

  private  

  def format_fb_friend_data(friend, middle_of_the_month)
    birthday_arr = friend.birthday.split("/")
    friend.birthday = "#{birthday_arr[1]}/#{birthday_arr[0]}"
    friend_hash = JSON.parse(friend.to_json)["table"]
    friend_hash["picture"] = "https://graph.facebook.com/#{friend_hash['uid']}/picture"
    if (middle_of_the_month && birthday_arr[1].to_i > 15) || (!middle_of_the_month && birthday_arr[1].to_i <= 15)
      "#{friend_hash['first_name']}|#{friend_hash['picture']}|#{friend_hash['birthday']}"
    else
      nil
    end    
  end
end
