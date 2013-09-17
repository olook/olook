# -*- encoding : utf-8 -*-
module Seo
  class SeoManager
    attr_accessor :url, :meta_tag

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
          self.meta_tag = url_path if url.match(url_path)
          break if url.match(url_path)
        end
      end
      def get_meta_tags_info
        file_dir = "#{Rails.root}/config/seo.yml"
        YAML::load(File.open(file_dir))
      end
  end
end
