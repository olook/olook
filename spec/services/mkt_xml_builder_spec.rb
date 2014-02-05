# -*- encoding : utf-8 -*-
require "spec_helper"

describe MktXmlBuilder do
  before do
    MktXmlBuilder.stub(:load_products).and_return([product])
  end

  let(:product) {FactoryGirl.create :blue_sliper_with_variants}

  context "for iLove Ecommerce" do

    it "build xml of products" do
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>
      <produto>
      <codigo>#{product.id}</codigo>
      <categoria>12</categoria>
      <link><![CDATA[http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&utm_content=#{product.id}&utm_medium=vitrine&utm_source=ilove_ecommerce]]></link>
      <imagem></imagem>
      <nome_titulo><![CDATA[#{product.name}]]></nome_titulo>
      <descricao><![CDATA[#{product.description}]]></descricao>
      <preco_real>#{product.price}</preco_real>
      <preco_desconto>#{product.retail_price}</preco_desconto>
      <specific>
      <marca><![CDATA[OLOOK]]></marca>
      <cor></cor>
      <tamanho></tamanho>
      <autor></autor>
      <artista></artista>
      <editora></editora>
      <ritmo></ritmo>
      <distribuidora></distribuidora>
      <sinopse></sinopse>
      <loja>olook</loja>
      </specific>
      </produto>
      </produtos>
      END
      result = Nokogiri::XML(MktXmlBuilder.create_xml([:ilove_ecommerce])[:ilove_ecommerce])
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true}).should be_true
    end

  end

  context "When have 1 product" do


    it "build xml of products" do
      content = <<-XML.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>

        <produto>
          <codigo>#{product.id }</codigo>
          <categoria>12</categoria>
          <link><![CDATA[#{product.product_url(:utm_source =>"nanointeractive", :utm_campaign => "produtos", :utm_medium => "remarketing").html_safe}]]></link>
          <imagem></imagem>
          <nome_titulo><![CDATA[#{product.name }]]></nome_titulo>
          <descricao><![CDATA[#{ product.description }]]></descricao>
          <preco_real>#{ product.price }</preco_real>
          <preco_desconto>#{ product.retail_price }</preco_desconto>
          <specific>
            <marca><![CDATA[#{ product.brand }]]></marca>
            <cor></cor>
            <tamanho></tamanho>
            <autor></autor>
            <artista></artista>
            <editora></editora>
            <ritmo></ritmo>
            <distribuidora></distribuidora>
            <sinopse></sinopse>
            <loja>olook</loja>
          </specific>
      </produto>
      XML
      result = Nokogiri::XML(MktXmlBuilder.create_xml([:nano])[:nano])
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true}).should be_true
    end
  end
end
