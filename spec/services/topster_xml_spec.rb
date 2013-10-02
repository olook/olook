# -*- encoding : utf-8 -*-
require "spec_helper"

describe TopsterXml do

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