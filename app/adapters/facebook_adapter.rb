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
    facebook_friends.collect {|item| item.uid}
  end

  def olook_facebook_friends
    User.find_all_by_uid facebook_friends_ids
  end

  def post_wall_message(message, *args)
    options = args.extract_options!
    @adapter.put_wall_post(message, options[:attachment] || {}, options[:target] || "me", options[:options] || {})
  end
end
