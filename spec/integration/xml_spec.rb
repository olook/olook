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
      <producturl>http://www.olook.com.br/produto/#{product.id}?utm_campaign=remessaging&amp;utm_content=#{product.id}&amp;utm_medium=banner&amp;utm_source=criteo</producturl>
      <description>#{product.description}</description>
      <price>#{product.price}</price>
      <retailprice>#{product.price}</retailprice>
      <recommendable>1</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category}</category>
      </product>
      </products>
      END
    end
  end

  context "in the mt_perfomance xml page" do
    scenario "I want to see products of mt_perfomance" do
      visit mt_perfomance_path
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <produtos>
      <produto>
      <nome>#{product.name}</nome>
      <descricao>#{product.description}</descricao>
      <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=remessaging&amp;utm_content=#{product.id}&amp;utm_medium=banner&amp;utm_source=criteo</url>
      <imagem></imagem>
      <marca>olook</marca>
      <preco>#{product.price}</preco>
      <preco_original>#{product.price}</preco_original>
      <categoria>#{product.category}</categoria>
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
      <id_produto>#{product.id}</id_produto>
      <link_produto>http://www.olook.com.br/produto/#{product.id}?utm_campaign=remessaging&amp;utm_content=#{product.id}&amp;utm_medium=banner&amp;utm_source=criteo</link_produto>
      <nome_produto>#{product.name}</nome_produto>
      <marca>olook</marca>
      <categoria>#{ product.category}</categoria>
      <cores><cor>#{ product.color_name}</cor></cores>
      <descricao>#{ product.description}</descricao>
      <preco_de>#{ ActionController::Base.helpers.number_to_currency(product.price, :unit => "") }</preco_de>
      <preco_por>#{ ActionController::Base.helpers.number_to_currency(product.price, :unit => "")}</preco_por>
      <parcelamento>1</parcelamento>
      <imagens>
      </imagens>
      </produto>
      </produtos>
      END
    end
  end
end
