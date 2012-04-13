# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Show products on xml format" do
  let!(:bag) { FactoryGirl.create :basic_bag }
  let!(:product) { FactoryGirl.create :basic_shoe }

  background do
    product.master_variant.update_attribute(:price, 99.90)
    product.master_variant.update_attribute(:inventory, 1)
  end

  context "in the criteo xml page" do
    scenario "I want to see products of criteo" do
      visit criteo_path
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <products>
      <product id="#{product.id}">
      <name>#{product.name}</name>
      <smallimage></smallimage>
      <bigimage></bigimage>
      <producturl>http://www.olook.com.br/produto/#{product.id}?utm_campaign=remessaging&amp;utm_content=#{product.id}&amp;utm_medium=banner&amp;utm_source=criteo</producturl>
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
    context "when product is in stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(false)
      end
      
      scenario "I want to see products of mt_perfomance" do
        visit mt_performance_path
        page.source.should == <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        <produto>
        <nome><![CDATA[#{product.name}]]></nome>
        <descricao><![CDATA[#{product.description}]]></descricao>
        <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=mt_performance</url>
        <imagem></imagem>
        <marca>olook</marca>
        <preco>#{ActionController::Base.helpers.number_with_precision(product.retail_price, :precision => 2)}</preco>
        <preco_original>#{ActionController::Base.helpers.number_with_precision(product.price, :precision => 2)}</preco_original>
        <categoria>#{Category.t(product.category)}</categoria>
        </produto>
        </produtos>
        END
      end
    end
    
    context "when product is out of stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(true)
      end
      
      scenario "I see an empty XML" do
        visit mt_performance_path
        page.source.should == <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        </produtos>
        END
      end
    end

  end

  context "in the click a porter xml page" do
    
    context "when product is in stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(false)
      end
      
      scenario "I want to see products of click a porter" do
        visit click_a_porter_path
        page.source.should == <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        <produto>
        <id_produto><![CDATA[#{product.id}]]></id_produto>
        <link_produto><![CDATA[http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=click_a_porter]]></link_produto>
        <nome_produto><![CDATA[#{product.name}]]></nome_produto>
        <marca><![CDATA[olook]]></marca>
        <categoria><![CDATA[#{Category.t(product.category)}]]></categoria>
        <cores><cor><![CDATA[#{ product.color_name}]]></cor></cores>
        <descricao><![CDATA[#{ product.description}]]></descricao>
        <preco_de><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.price, :precision => 2) }]]></preco_de>
        <preco_por><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.retail_price, :precision => 2)}]]></preco_por>
        <parcelamento><![CDATA[3 x 33,30]]></parcelamento>
        <imagens>
        </imagens>
        </produto>
        </produtos>
        END
      end
    end
    
    context "when product is out of stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(true)
      end
      
      scenario "I see an empty XML" do
        visit click_a_porter_path
        page.source.should == <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        </produtos>
        END
      end
    end
    
  end
end
