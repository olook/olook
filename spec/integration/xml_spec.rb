# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Show products on xml format" do
  let!(:bag) { FactoryGirl.create :basic_bag }
  let!(:product) { FactoryGirl.create :basic_shoe }

  background do
    product.master_variant.update_attribute(:price, 1.0)
  end

  context "in the criteo xml page" do
    scenario "I want to see products of criteo" do
      visit criteo_path
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <products>
      <product id="#{product.id}">
      <name>#{product.name}</name>
      <smallimage></smallimage>
      <bigimage></bigimage>
      <producturl>http://www.olook.com.br/produto/#{product.id}?utm_campaign=remessaging&utm_content=#{product.id}&utm_medium=banner&utm_source=criteo</producturl>
      <description>#{product.description}</description>
      <price>#{product.price}</price>
      <retailprice>#{product.retail_price}</retailprice>
      <recommendable>1</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category}</category>
      </product>
      </products>
      END
    end
  end

  context "in the mt_performance xml page" do
    scenario "I want to see products of mt_perfomance" do
      visit mt_performance_path
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <produtos>
      <produto>
      <nome>#{product.name}</nome>
      <descricao>#{product.description}</descricao>
      <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&utm_content=#{product.id}&utm_medium=vitrine&utm_source=mt_performance</url>
      <imagem></imagem>
      <marca>olook</marca>
      <preco>#{product.price}</preco>
      <preco_original>#{product.retail_price}</preco_original>
      <categoria>#{Category.t(product.category)} - #{product.subcategory}</categoria>
      </produto>
      </produtos>
      END
    end
  end

  context "in the click a porter xml page" do
    scenario "I want to see products of click a porter" do
      visit click_a_porter_path
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <produtos>
      <produto>
      <id_produto><![CDATA[#{product.id}]]></id_produto>
      <link_produto><![CDATA[http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&utm_content=#{product.id}&utm_medium=vitrine&utm_source=click_a_porter]]></link_produto>
      <nome_produto><![CDATA[#{product.name}]]></nome_produto>
      <marca><![CDATA[olook]]></marca>
      <categoria><![CDATA[#{Category.t(product.category)} - #{product.subcategory}]]></categoria>
      <cores><cor><![CDATA[#{ product.color_name}]]></cor></cores>
      <descricao><![CDATA[#{ product.description}]]></descricao>
      <preco_de><![CDATA[#{ ActionController::Base.helpers.number_to_currency(product.price, :unit => "") }]]></preco_de>
      <preco_por><![CDATA[#{ ActionController::Base.helpers.number_to_currency(product.price, :unit => "")}]]></preco_por>
      <parcelamento><![CDATA[um]]></parcelamento>
      <imagens>
      </imagens>
      </produto>
      </produtos>
      END
    end
  end
end
