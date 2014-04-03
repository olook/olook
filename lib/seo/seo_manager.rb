# -*- encoding : utf-8 -*-
module Seo
  class SeoManager
    DEFAULT_PAGE_TITLE = 'Sapatos Femininos e Roupas Femininas'
    DEFAULT_PAGE_DESCRIPTION = 'test'

    attr_accessor :url, :page_title, :page_description

    def initialize url, options={}
      @url = URI.decode(url).gsub(" ", "-").downcase
    end

    def select_meta_tag
      choose_meta_tag
    end

    private

      def choose_meta_tag
        title = search_meta_tag[:title] || DEFAULT_PAGE_TITLE
        description = search_meta_tag[:description] || DEFAULT_PAGE_DESCRIPTION
        {title: "#{title} | Olook" , description: description}
      end

      def search_meta_tag
        header = find_parent_meta_tag(url.dup)
        {title: header.try(:page_title), description: header.try(:page_description)}
      end

      def find_parent_meta_tag(_url)
        return nil if _url.blank? || _url[0] != "/"
        header = Header.for_url(_url).first
        return header if header
        find_parent_meta_tag(_url.sub(%r{/[^/]*$}, ''))
      end
  end
end
