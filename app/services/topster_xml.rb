# -*- encoding : utf-8 -*-
class TopsterXml
  require 'builder'
  extend ActionView::Helpers::XmlHelper
  extend ActionView::Helpers::NumberHelper

  def self.create_xml
    @products = Product.where(is_visible: true).last(5)
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "UTF-8"
    xml.produtos do |xml|
      @products.each do |product|
        xml.id_produto { xml.cdata!(product.id.to_s) }
        xml.link_produto { xml.cdata!(product.product_url(:utm_source => "topster").to_s) }
        xml.nome_produto { xml.cdata!(product.name.to_s) }
        xml.marca { xml.cdata!("Olook") }
        xml.categoria { xml.cdata!(full_category(product).to_s) }
        xml.cores do
          xml.cor { xml.cdata!(product.color_name.to_s) }
        end
        xml.descricao { xml.cdata!(product.description.to_s) }
        xml.preco_de { xml.cdata!(number_with_precision(product.price, :precision => 2).to_s) }
        xml.preco_por { xml.cdata!(number_with_precision(product.retail_price, :precision => 2).to_s) }
        xml.parcelamento { xml.cdata!(build_installment_text(product.retail_price).to_s) }
        xml.imagens do
          product.pictures.order(:position).each do |picture|
            xml.imagem { xml.cdata!(picture.image.to_s) }
          end
        end
        xml.estoque { xml.cdata!(product.inventory > 0 ? "sim" : "não" ) }
        xml.estoque_baixo { xml.cdata!(product.inventory > 2 ? "não" : "sim" ) }
        xml.num_tams do
          product.variants.each do |variant|
            xml.num_tam { xml.cdata!(variant.description.to_s ) }
          end
        end
      end
    end
  end

  def self.send_to_amazon (xml)
    bucket = ENV["RAILS_ENV"] == 'production' ? 'cdn-app' : 'cdn-app-staging'
    connection = Fog::Storage.new({
      :provider   => 'AWS'
    })
    directory = connection.directories.get(bucket)
    directory.files.create(
      :key    => 'xml/topster_data.xml',
      :body   => xml,
      "Content-Type" => "application/xml",
      :public => true)
  end
end
