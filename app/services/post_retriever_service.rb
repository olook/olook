# -*- encoding : utf-8 -*-
class PostRetrieverService

  attr_accessor :wp

  def initialize(host, path, username, password)
    @wp = Rubypress::Client.new(:host => "stylist-news.olook.com.br", :path => "/xmlrpc.php", :username => "admin", :password => "olooksurubim951")    
  end

  def retrieve_posts number = 3
    retrieve_post_data number
  end

  private

    def retrieve_post_data number
      posts = wp.getPosts(:filter =>{:order => "desc", :orderby => "post_date", :post_type => 'post', :post_status => 'publish', :number => number})
      posts.map do |post|
        {
          img: post["post_thumbnail"]["link"],
          link: post["link"],
          title: post["post_title"],
          subtitle: post["custom_fields"].select{|cf| cf["key"] == "wps_subtitle"}.first["value"]
        }
      end
    end
end
