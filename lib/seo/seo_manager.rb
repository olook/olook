# -*- encoding : utf-8 -*-

require 'yaml'

module Seo
  class SeoManager
    attr_accessor :url, :meta_tag
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config/seo.yml'))
    @@file = YAML::load(File.open(FILENAME))

    def initialize url_params, options={}
      @url = url_params
      @model = options[:model] if options[:model]
    end

    def select_meta_tag
      choose_meta_tag
    end

    private
      def choose_meta_tag
        search_meta_tag
        if meta_tag
          get_meta_tags_info[meta_tag]
        elsif @model && @model.respond_to?(:title_text)
          @model.title_text
        else
          'Sapatos Femininos e Roupas Femininas | Olook'
        end
      end

      def search_meta_tag
        get_meta_tags_info.keys.select do |url_path|
          self.meta_tag = url_path if url.downcase == url_path.downcase
          break if url == url_path
        end
      end
      def get_meta_tags_info
        @@file
      end
  end
end
