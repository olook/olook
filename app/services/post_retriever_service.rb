# -*- encoding : utf-8 -*-
class PostRetrieverService

  def initialize(host, path, username, password)
    @wp = Rubypress::Client.new(:host => "stylist-news.olook.com.br", :path => "/xmlrpc.php", :username => "admin", :password => "olooksurubim951")    
  end

  def retrieve_posts
    Rails.cache.fetch("sn-post-data", :expires_in => 1.hour) do
      retrieve_post_data 1
    end
  end

  def gather_posts
    Rails.cache.write("sn-post-data", retrieve_post_data, :time_to_live => 1.hour)
  end

  private

    def retrieve_post_data(number = 3)
      posts(number).map do |post|        
        format_post post
      end
    end

    def posts number = 3
      @wp.getPosts(:filter =>{:order => "desc", :orderby => "post_date", :post_type => 'post', :post_status => 'publish', :number => number})      
    end

    def format_post post
      img_hash = process_images(post["post_thumbnail"]["link"])

      data_hash = {
        link: post["link"],
        title: post["post_title"], 
        subtitle: post["custom_fields"].select{|cf| cf["key"] == "wps_subtitle"}.first["value"]
      }

      data_hash.merge(img_hash)      
    end

    def process_images img
      uploader = BlogImageUploader.new
      uploader.download! img
      uploader.store!
      {img_old_home: uploader.versions[:old_home].url, img_new_home: uploader.versions[:new_home].url}
    end    
end
