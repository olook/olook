# -*- encoding : utf-8 -*-

require 'yaml'

module Seo
  class SeoManager
    CATEGORY_TEXT = {sapato: 'Sapatos Femininos', roupa: 'Roupas Femininas', acessorio: 'Bijuterias - Semi Joia e Bijuterias Finas', bolsa: 'Bolsas Femininas'}
    REMOVE_COLOR_REGEX = /\/(cor|tamanho)-(.*)$/
    DEFAULT_META_TAG_TEXT = 'Sapatos Femininos e Roupas Femininas'

    attr_accessor :url, :meta_tag, :color, :model, :category, :subcategory
    FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config/seo.yml'))
    @@file = YAML::load(File.open(FILENAME))

    def initialize url_params, options={}
      @brand = options[:search].expressions[:brand] if options[:search]
      @collection_theme = options[:search].expressions[:collection_theme] if options[:search]
      @color = options[:search].expressions[:color] if options[:search]
      @category = options[:search].expressions[:category] if options[:search]
      @subcategory = options[:search].expressions[:subcategory] if options[:search]
      @url = url_params.gsub(REMOVE_COLOR_REGEX,'')
      @model = options[:model] || OpenStruct.new({title_text: nil})
    end

    def select_meta_tag
      choose_meta_tag
    end

    def color_formatted
      color.map(&:capitalize).join(" ") if color
    end

    private

      def choose_meta_tag
        search_meta_tag
        "#{(extract_meta_tag_text || DEFAULT_META_TAG_TEXT)} | Olook"
      end

      def extract_meta_tag_text
        if model.title_text
          return "#{model.title_text} #{color_formatted}" if color
          model.title_text
        elsif category
          category_meta_tag
        else
          get_meta_tags_info[meta_tag.to_s]
        end
      end

      def category_meta_tag
        subcategory_name = extract_subcategories unless subcategory.blank?
        category_name = category.first unless category.blank?
        return "#{subcategory_name} #{color_formatted}" if !subcategory.blank? && !color.blank?
        return "#{subcategory_name}" unless subcategory.blank?
        return "#{CATEGORY_TEXT[category_name.to_sym]} #{color_formatted}" if !category.blank? && !color.blank?
        return "#{CATEGORY_TEXT[category_name.to_sym]}" if category
      end

      def extract_subcategories
       if subcategory.size > 3
         "#{subcategory.map(&:capitalize).first(3).join(" - ")} e outros"
       else
         subcategory.map(&:capitalize).join(" - ")
       end
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
