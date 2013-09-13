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

  end
end
