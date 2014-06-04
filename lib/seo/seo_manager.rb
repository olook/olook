# -*- encoding : utf-8 -*-
module Seo
  class SeoManager
    DEFAULT_PAGE_TITLE = 'Roupas e sapatos femininos online'
    DEFAULT_PAGE_DESCRIPTION = 'Na Olook você compra os sapatos, acessórios e roupas femininas mais visados da moda com segurança e facilidade.'

    attr_accessor :url, :fallback_title, :fallback_description, :color, :size, :brand

    def initialize url, options={}
      @url = URI.decode(url).gsub(" ", "-").downcase
      @fallback_title = options[:fallback_title]
      @fallback_description = options[:fallback_description]
      @color = format_var options[:color]
      @size = format_var options[:size] do |s|
        s.to_s.gsub(/(s|r)/, "")
      end
      @brand = format_var options[:brand]
    end

    def select_meta_tag
      choose_meta_tag
    end

    private

    def format_var(var, &block)
      if var.respond_to?(:join)
        var.map! do |v|
          v = block.call(v) if block
          v.capitalize
        end
        var = var.join(' ')
      end

      unless var.respond_to?(:capitalize)
        var = var.to_s
      end
      var.capitalize
    end

    def choose_meta_tag
      meta_tag = search_meta_tag

      title = meta_tag[:title] || fallback_title || DEFAULT_PAGE_TITLE
      description = meta_tag[:description] || fallback_description || DEFAULT_PAGE_DESCRIPTION
      full_title = title
      full_title+= " #{color}" unless color.blank?
      full_title+= " Tamanho #{size}" unless size.blank?
      full_title+= " #{brand}" unless brand.blank?
      {title: "#{full_title} | Olook" , description: description}
    end

    def search_meta_tag
      _url = url.dup
      _url = _url.gsub("-#{brand.downcase}", "") if brand
      header = find_parent_meta_tag(_url)
      {title: header.try(:page_title), description: header.try(:page_description)}
    end

    def find_parent_meta_tag(_url)
      return nil if _url.blank? || _url[0] != "/"
      header = Header.for_url(_url).first
      return header if header
      find_parent_meta_tag(_url.sub(%r{/[^/]*$}, ''))
    rescue ActiveRecord::StatementInvalid
      nil
    end
  end
end
