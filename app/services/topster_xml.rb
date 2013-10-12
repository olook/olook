# -*- encoding : utf-8 -*-
  require 'builder'

class TopsterXml
  extend XmlHelper
  extend ActionView::Helpers::NumberHelper

  RENDERERS = {
    nextperformance: 'nextperformance_template.xml.erb',
    topster: 'topster_template.xml.erb',
    criteo: 'criteo_template.xml.erb',
    triggit: 'triggit_template.xml.erb',
    sociomantic: 'sociomantic_template.xml.erb',
    parceirosmkt: 'ilove_ecommerce_template.xml.erb',
    ilove_ecommerce: 'ilove_ecommerce_template.xml.erb',
    nano_interactive: 'nano_interactive_template.xml.erb',
    adroll: 'adroll_template.xml.erb',
    zanox: 'zanox_template.xml.erb',
    afilio: 'afilio_template.xml.erb',
    mt_performance: 'mt_performance_template.xml.erb',
    click_a_porter: 'click_a_porter_template.xml.erb',
    netaffiliation: 'netaffiliation_template.xml.erb',
    shopping_uol: 'shopping_uol_template.xml.erb',
    google_shopping: 'google_shopping_template.xml.erb',
    struq: 'struq_template.xml.erb',
    kuanto_kusta: 'kuanto_kusta_template.xml.erb',
    muccashop: 'muccashop_template.xml.erb',
    shopear: 'shopear_template.xml.erb'
  }

  def self.create_xmls
    create_xml(RENDERERS.keys)
  end

  def self.create_xml(templates)
    xmls = {}
    @products = load_products

    templates.each do |template_name|
      xmls[template_name] = generate_for(template_name)
    end

    xmls
  end

  def self.upload(xmls)
    xmls.each {|template_name, xml| send_to_amazon(xml, "#{template_name}_data.xml") }
  end

  private

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


    def self.generate_for(template_name)
      begin
        renderer = get_renderer(template_name)
        renderer.result(binding)
      rescue => e
        puts "[XML] Erro ao processar template #{template_name}: #{e}"
      end
    end

    def self.get_renderer(template_name)
      begin
        template_file_path = "app/views/xml/" + RENDERERS.fetch(template_name)
        ERB.new(File.read(template_file_path))
      rescue KeyError
        OpenStruct.new({result: ""})
      end      
    end

    def self.load_products
      # This method was copied from XmlController
      products = Product.valid_for_xml(Product.xml_blacklist("products_blacklist").join(','))     
      @liquidation_products = []
      active_liquidation = LiquidationService.active
      @liquidation_products = active_liquidation.resume[:products_ids] if active_liquidation
      products + @liquidation_products
    end
end
