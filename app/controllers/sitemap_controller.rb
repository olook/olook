class SitemapController < ApplicationController
  layout "lite_application"
  def index
    @url_builder = SeoUrl.new(search: SearchEngine.new)
    prepare_sections_variables
  end

  private
  def prepare_sections_variables
    @brands = retreive_section_info["brands"]
    @collection_themes = retreive_section_info["collection_themes"]
    @shoes = retreive_section_info["shoes"]
    @accessories = retreive_section_info["accessories"]
    @bags = retreive_section_info["bags"]
    @cloths = retreive_section_info["cloths"]
  end

  def retreive_section_info
    data = ActiveSupport::JSON.decode(redis.get("sitemap"))
    data
  end

  def redis
    Redis.new
  end
end
