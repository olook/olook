# -*- encoding : utf-8 -*-
module Seo
  class SeoManager
    attr_accessor :url

    def initialize url_params
      @url = url_params
    end

    def meta_tag
      "olook"
    end

    def get_meta_tags_info
      file_dir = "#{Rails.root}/config/seo.yml"
    end

  end
end
