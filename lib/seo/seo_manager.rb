# -*- encoding : utf-8 -*-

require 'yaml'

module Seo
  class SeoManager

    EXTRACT_COLOR_REGEX = /cor-(\w*)$/
    REMOVE_COLOR_REGEX = /\/(cor|tamanho)-(.*)$/
    DEFAULT_META_TAG_TEXT = 'Sapatos Femininos e Roupas Femininas | Olook'

    attr_accessor :url, :meta_tag, :color, :model
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config/seo.yml'))
    @@file = YAML::load(File.open(FILENAME))

    def initialize url_params, options={}
      @url = extract_base_url_from(url_params)
      @model = options[:model] || OpenStruct.new({title_text: nil})
      match_data = EXTRACT_COLOR_REGEX.match(url_params)
      @color = match_data && match_data[1]
    end

    def select_meta_tag
      choose_meta_tag
    end

    private

      def extract_base_url_from url
        arr = url.split("/")
        arr.first.empty? ? "/#{arr.second}" : "/#{arr.first}"        
      end

      def choose_meta_tag
        search_meta_tag
        meta_tag_text = extract_meta_tag_text || DEFAULT_META_TAG_TEXT

        replace_placeholder_by_color_if_needed(meta_tag_text)
      end

      def extract_meta_tag_text
        model.title_text || get_meta_tags_info[meta_tag.to_s]
      end

      def replace_placeholder_by_color_if_needed(text)
        color ? text.gsub(/feminin[ao]s/i, @color.titleize) : text
      end

      def search_meta_tag
        get_meta_tags_info.keys.select do |url_path|
          if url.downcase == url_path.downcase
            self.meta_tag = url_path 
            break
          end
        end
      end

      def get_meta_tags_info
        @@file
      end
  end
end
