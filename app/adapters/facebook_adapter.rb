# -*- encoding : utf-8 -*-
class FacebookAdapter
  attr_accessor :access_token, :adapter

  def initialize(access_token, adapter = Koala::Facebook::API)
    @access_token, @adapter = access_token, adapter.new(access_token)
  end

  def facebook_friends fields="name, gender, birthday, first_name"
    @result ||= begin
      friends = adapter.get_connections("me", "friends", :fields => fields)
      filter_female_friends(friends).map {|friend| OpenStruct.new(:uid => friend["id"], :name => friend["name"], :birthday => friend["birthday"], :first_name => friend["first_name"])}
    end
  end
  
  def filter_female_friends friends
    friends.select{|friend| friend["gender"] == "female"}
  end

  def facebook_friends_ids
    facebook_friends.map(&:uid)
  end
  
  def facebook_friends_with_birthday month=nil
    friends = []
    facebook_friends.select{|friend| friend.birthday }.each do |friend|
      begin
        if Date.strptime(friend.birthday, "%m/%d/%Y").month.to_s == month.to_s
          friends << friend
        end
      rescue
      end
    end
    friends.sort_by{|f| f.birthday}
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
end
