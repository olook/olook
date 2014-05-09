class SitemapController < ApplicationController
  layout "lite_application"
  def index
    @url_builder = SeoUrl.new(search: SearchEngine.new)
    prepare_sections_variables
  end

  private
  def prepare_sections_variables
    data = retrieve_section_info
    @brands = data["brands"]
    @collection_themes = data["collection_themes"]
    @shoes = data["shoes"]
    @accessories = data["accessories"]
    @bags = data["bags"]
    @cloths = data["cloths"]
  end

  def retrieve_section_info
    ActiveSupport::JSON.decode(redis.get("sitemap"))
  end

  def redis
    Redis.connect(url: ENV['REDIS_SITEMAP'])
  end
end
