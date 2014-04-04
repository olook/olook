# -*- encoding : utf-8 -*-
module Seo
  class SeoManager
    DEFAULT_PAGE_TITLE = 'Olook - Roupas e sapatos femininos online'
    DEFAULT_PAGE_DESCRIPTION = 'Na Olook você compra os sapatos, acessórios e roupas femininas mais visados da moda com segurança e facilidade.'

    attr_accessor :url, :fallback_title, :fallback_description

    def initialize url, options={}
      @url = URI.decode(url).gsub(" ", "-").downcase
      @fallback_title = options[:fallback_title]
      @fallback_description = options[:fallback_description]
    end

    def select_meta_tag
      choose_meta_tag
    end

    private

      def choose_meta_tag
        title = search_meta_tag[:title] || fallback_title || DEFAULT_PAGE_TITLE
        description = search_meta_tag[:description] || fallback_description || DEFAULT_PAGE_DESCRIPTION
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
