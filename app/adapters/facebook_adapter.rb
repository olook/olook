# -*- encoding : utf-8 -*-
class FacebookAdapter
  attr_accessor :access_token, :adapter

  def initialize(access_token, adapter = Koala::Facebook::API)
    @access_token, @adapter = access_token, adapter.new(access_token)
  end

  def facebook_friends
    @result ||= begin
      friends = adapter.get_connections("me", "friends", :fields => "name, gender")
      male_friends = friends.select{|friend| friend["gender"] == "female"}
      male_friends.map {|friend| OpenStruct.new(:uid => friend["id"], :name => friend["name"])}
    end
  end

  def facebook_friends_ids
    facebook_friends.map(&:uid)
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
