# -*- encoding : utf-8 -*-
  require 'builder'

class TopsterXml
  extend XmlHelper
  extend ActionView::Helpers::NumberHelper

  def self.create_xml(templates)
    @products = Product.last(4)
    # xml = Builder::XmlMarkup.new( :indent => 2 )
    # xml.instruct! :xml, :encoding => "UTF-8"
    # xml.produtos do |xml|
    xmls = {}
    templates.each do |template_name|
      xml = Builder::XmlMarkup.new( :indent => 2 )
      xml.instruct! :xml, :encoding => "UTF-8"
      
      xmls[template_name] = xml
    end

    templates.each do |template_name|
      xmls[template_name] = '<?xml version="1.0" encoding="UTF-8"?><products>'
      @products.each do |product|
        xmls[template_name] += generate_for(template_name, product)
      end
      xmls[template_name] += '</products>'
    end

    p xmls

    #     xml.produto do
    #       xml.id_produto { xml.cdata!(product.id.to_s) }
    #       xml.link_produto { xml.cdata!(product.product_url(:utm_source => "topster").to_s) }
    #       xml.nome_produto { xml.cdata!(product.name.to_s) }
    #       xml.marca { xml.cdata!("olook") }
    #       xml.categoria { xml.cdata!(full_category(product).to_s) }
    #       xml.cores do
    #         xml.cor { xml.cdata!(product.color_name.to_s) }
    #       end
    #       xml.descricao { xml.cdata!(product.description.to_s) }
    #       xml.preco_de { xml.cdata!(number_with_precision(product.price, :precision => 2).to_s) }
    #       xml.preco_por { xml.cdata!(number_with_precision(product.retail_price, :precision => 2).to_s) }
    #       xml.parcelamento { xml.cdata!(build_installment_text(product.retail_price).to_s) }
    #       xml.imagens do
    #         product.pictures.order(:position).each do |picture|
    #           xml.imagem { xml.cdata!(picture.image.to_s) }
    #         end
    #       end
    #       xml.estoque { xml.cdata!(product.inventory > 0 ? "sim" : "não" ) }
    #       xml.estoque_baixo { xml.cdata!(product.inventory >= 2 ? "não" : "sim" ) }
    #     end
    #   end
    # end
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
      end

      renderer.result(binding)
    end

 end
