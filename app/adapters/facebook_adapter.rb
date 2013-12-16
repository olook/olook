# -*- encoding : utf-8 -*-
class FacebookAdapter
  attr_accessor :access_token, :adapter

  def initialize(access_token, adapter = Koala::Facebook::API)
    @access_token, @adapter = access_token, adapter.new(access_token)
  end

  def facebook_friends(fields = "name, gender, birthday, first_name")
    Rails.cache.fetch(access_token, :expires_in => 15.minutes) do
      begin
        friends = adapter.get_connections("me", "friends", :fields => fields)
      rescue => e
        puts "Error on getting facebook data for token #{@access_token}"
        friends = []
      end
      filter_female_friends(friends).map do |friend|
        OpenStruct.new(:uid => friend["id"],
         :name => friend["name"],
         :first_name => friend["first_name"],
         :birthday => friend["birthday"]
        )
      end
    end
  end

  def filter_female_friends friends
    friends.select{|friend| friend["gender"] == "female"}
  end

  def facebook_friends_ids
    facebook_friends.map(&:uid)
  end

  def facebook_friends_without_cache_fetch(fields = "name, gender, birthday, first_name")
    friends = adapter.get_connections("me", "friends", :fields => fields)
    filter_female_friends(friends).map do |friend|
      OpenStruct.new(:uid => friend["id"],
       :name => friend["name"],
       :first_name => friend["first_name"],
       :birthday => friend["birthday"]
      )
    end    
  end

  def facebook_friends_with_birthday month
    friends = []
    begin
      self.facebook_friends_without_cache_fetch.select{|friend| friend.birthday }.compact.each do |friend|
        begin
          if Date.strptime(friend.birthday, "%m/%d").month.to_s == month.to_s
            friends << friend
          end
        rescue
        end
      end
      if friends.empty?
        friends
      else
        friends.sort_by{|f| f.birthday}
      end
    rescue => e
      Rails.logger.warn(e.message)
    end
    friends
  end

  def facebook_friends_registered_at_olook
    User.find_all_by_uid facebook_friends_ids
  end

  def facebook_friends_not_registered_at_olook
    facebook_friends_registered_at_olook_uids = facebook_friends_registered_at_olook.map(&:uid)
    facebook_friends.select{|friend| !facebook_friends_registered_at_olook_uids.include?(friend.uid)}
  end

  def post_wall_message(message, *args)
    options = args.extract_options!
    adapter.put_wall_post(message, options[:attachment] || {}, options[:target] || "me", options[:options] || {})
  end

  def friends_structure
    friends_not_registred = facebook_friends_not_registered_at_olook
    [friends_not_registred, facebook_friends_registered_at_olook, friends_not_registred.shuffle.first]
  end
  
  def retrieve_user_data
    user_data = adapter.get_object("me")
    OpenStruct.new(picture: "https://graph.facebook.com/#{user_data['id']}/picture?width=65&height=60", name: user_data['name'])
  end  
end
