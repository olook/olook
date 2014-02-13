# -*- encoding : utf-8 -*-
  require 'builder'

class MktXmlBuilder
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
    nano: 'nano_template.xml.erb',
    nano_interactive: 'nano_interactive_template.xml.erb',
    zanox: 'zanox_template.xml.erb',
    afilio: 'afilio_template.xml.erb',
    mt_performance: 'mt_performance_template.xml.erb',
    netaffiliation: 'netaffiliation_template.xml.erb',
    google_shopping: 'google_shopping_template.xml.erb',
    muccashop: 'muccashop_template.xml.erb',
    shopear: 'shopear_template.xml.erb',
    melt: 'melt_template.xml.erb',
    paraiso_feminino: 'paraiso_feminino_template.xml.erb',
    stylight: 'stylight_template.xml.erb',
    all_in: 'all_in.xml.erb',
    zoom: 'zoom_template.xml.erb',
    buscape: 'buscape_template.xml.erb'
  }

  def self.create_xmls
    create_xml(RENDERERS.keys)
  end

  def self.create_xml(templates)
    xmls = {}
    @products = load_products
    @products_for_mercadolivre = Product.where({id: [18541,18519,18539,18537,18525,18543,18527,18555,18557,18567,18531,18561,18547,18535,18553,18533,18569,18529,18559,18545,18890,18551,18549,18515,14628,17689,18517,14626,21987,18914,18916,14624,14644,15870,18874,22009,18882,1748010017,14630,14616,3220,4380,11533,14086,17822,18751,18753,19571,19573,19575,19577,19992,20006,20044,20074,20076,20088,20122,20144,20600,20606,20899,20901,21359,21391,21395,21403,21407,21419,21421,22350,22352,22597,22601,22617,22623,22625,22627,22629,22883,22887,22889,22891,22893,22895,22897,22899,22901,22903,22913,22915,22917,22919,90370,7069,13213,14552,14596,14634,14638,14640,14646,14654,14662,14674,14764,17708,18229,18511,18565,18866,18872,18910,21371,21989,21995]})

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
      Product.valid_for_xml(Product.xml_blacklist("products_blacklist").join(','))
    end
end
