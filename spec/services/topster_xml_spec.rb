# -*- encoding : utf-8 -*-
require "spec_helper"

describe TopsterXml do

  context "for iLove Ecommerce" do
    before do
      TopsterXml.stub(:load_products).and_return([product])
    end

    let(:product) {FactoryGirl.create :blue_sliper_with_variants}

    it "build xml of products" do
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>
      <produto>
      <codigo>#{product.id}</codigo>
      <categoria>12</categoria>
      <link><![CDATA[http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&utm_content=#{product.id}&utm_medium=vitrine&utm_source=ilove_ecommerce]]></link>
      <imagem></imagem>
      <nome_titulo>#{product.name}</nome_titulo>
      <descricao>#{product.description}</descricao>
      <preco_real>#{product.price}</preco_real>
      <preco_desconto>#{product.retail_price}</preco_desconto>
      <specific>
      <marca>OLOOK</marca>
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
      result = Nokogiri::XML(TopsterXml.create_xml([:ilove_ecommerce])[:ilove_ecommerce])
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true}).should be_true
    end

  end

  context "When have 1 product" do
    let(:product) {FactoryGirl.create :shoe}

    before do
      TopsterXml.stub(:load_products).and_return([product])
    end

    it "build xml of products" do
      content = <<-XML.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>
        <produto>
          <id_produto>
            <![CDATA[#{product.id}]]>
          </id_produto>
          <link_produto>
            <![CDATA[#{product.product_url(:utm_source => "topster")}]]>
          </link_produto>
          <nome_produto>
            <![CDATA[#{product.name}]]>
          </nome_produto>
          <marca>
            <![CDATA[OLOOK]]>
          </marca>
          <categoria>
            <![CDATA[Sapato]]>
          </categoria>
          <cores>
            <cor>
              <![CDATA[Black]]>
            </cor>
          </cores>
          <descricao>
            <![CDATA[#{product.description}]]>
          </descricao>
          <preco_de>
            <![CDATA[0,00]]>
          </preco_de>
          <preco_por>
            <![CDATA[0,00]]>
          </preco_por>
          <parcelamento>
            <![CDATA[1 x 0.00]]>
          </parcelamento>
          <imagens>
          </imagens>
          <estoque>
            <![CDATA[não]]>
          </estoque>
          <estoque_baixo>
            <![CDATA[sim]]>
          </estoque_baixo>
        </produto>
      </produtos>
      XML

      equivalent_content = Nokogiri::XML(content)
      result = TopsterXml.create_xml([:topster])[:topster]
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end
end