# -*- encoding : utf-8 -*-
class PostRetrieverService

  def initialize(host, path, username, password)
    @wp = Rubypress::Client.new(:host => "stylist-news.olook.com.br", :path => "/xmlrpc.php", :username => "admin", :password => "olooksurubim951")    
    @redis = Redis.connect(url: ENV['REDIS_CACHE_STORE'])
  end

  def retrieve_posts
    data = if @redis.exists("sn-post-data")
      JSON.parse(@redis.get("sn-post-data"))["data"]
    else
      post_data = retrieve_post_data
      if post_data.any?
        @redis.setex("sn-post-data", 1.hour, {data: post_data}.to_json)
      end
      post_data
    end

    data || []
  end

  def gather_posts
    post_data = retrieve_post_data
    @redis.setex("sn-post-data", 1.hour, {data: post_data}.to_json)
  end

  private

    def retrieve_post_data(number = 1)
      posts(number).map do |post|
        format_post post
      end
    end

    def posts number = 1
      @wp.getPosts(:filter =>{:order => "desc", :orderby => "post_date", :post_type => 'post', :post_status => 'publish', :number => number})      
    rescue
      []
    end

    def format_post post

      img_hash = process_images(post["post_thumbnail"]["link"]) if post["post_thumbnail"]

      data_hash = {
        link: post["link"],
        title: post["post_title"], 
        subtitle: post["custom_fields"].select{|cf| cf["key"] == "wps_subtitle"}.first["value"]
      }

      data_hash.merge(img_hash) if img_hash

    end

    def process_images img
      uploader = BlogImageUploader.new
      uploader.download! img
      uploader.store!
      {img_old_home: uploader.versions[:old_home].url, img_new_home: uploader.versions[:new_home].url}
    end    
end
