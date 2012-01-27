# -*- encoding : utf-8 -*-
class FacebookAdapter
  attr_accessor :access_token, :adapter

  def initialize(access_token, adapter = Koala::Facebook::API)
    @access_token, @adapter = access_token, adapter.new(access_token)
  end

  def facebook_friends
    friends = @adapter.get_connections("me", "friends")
    friends.collect {|friend| OpenStruct.new(:uid => friend["id"], :name => friend["name"])}
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
    @adapter.put_wall_post(message, options[:attachment] || {}, options[:target] || "me", options[:options] || {})
  end
end
