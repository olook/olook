# -*- encoding : utf-8 -*-
  require 'builder'

class TopsterXml
  extend XmlHelper
  extend ActionView::Helpers::NumberHelper

  def self.create_xml(templates)
    xmls = {}
    @products = load_products

    templates.each do |template_name|
      # TODO REFACTOR ALL THIS LOGIC
      #header
      xml = '<?xml version="1.0" encoding="UTF-8"?>'
      if (template_name == :nextperformance)
        xml += '<products>'
      elsif (template_name == :topster)
        xml += '<produtos>'
      end


      @products.each do |product|
        xml += generate_for(template_name, product)
      end

      # footer
      if (template_name == :nextperformance)
        xml += '</products>'
      elsif (template_name == :topster)
        xml += '</produtos>'
      end

      xmls[template_name] = xml
    end

    xmls
  end

  def self.send_to_amazon (xml, file_name)
    bucket = ENV["RAILS_ENV"] == 'production' ? 'cdn-app' : 'cdn-app-staging'
    connection = Fog::Storage.new({
      :provider   => 'AWS'
    })
    directory = connection.directories.get(bucket)
    directory.files.create(
      :key    => "xml/#{file_name}",
      :body   => xml,
      "Content-Type" => "application/xml",
      :public => true)
  end

  private
    def self.generate_for(template_name, product)
      if template_name == :nextperformance
        renderer = ERB.new(File.read('app/views/xml/nextperformance_template.xml.erb'))
      elsif template_name == :topster
        renderer = ERB.new(File.read('app/views/xml/topster_template.xml.erb'))
      end

      renderer.result(binding)
    end

    def self.load_products
      # This method was copied from XmlController
      products = Product.valid_for_xml(Product.xml_blacklist("products_blacklist").join(','))     
      liquidation_products = []
      active_liquidation = LiquidationService.active
      liquidation_products = active_liquidation.resume[:products_ids] if active_liquidation
      products + liquidation_products
    end

 end
