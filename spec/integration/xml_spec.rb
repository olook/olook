# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'
include ActionView::Helpers::NumberHelper
include XmlHelper

feature "Show products on xml format" do
  let!(:bag) { FactoryGirl.create :basic_bag }
  let!(:product) { FactoryGirl.create :blue_sliper_with_variants }

  background do
    product.master_variant.update_attribute(:price, "99.90")
    product.master_variant.update_attribute(:inventory, 1)
  end

  context "in the criteo xml page" do


    scenario "I  dont want to see products of criteo if has less variants" do
      product2 = FactoryGirl.create(:blue_sliper_with_two_variants)
      product2.master_variant.update_attribute(:price, "99.90")
      product2.master_variant.update_attribute(:inventory, 1)
      visit criteo_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
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
      <discount>#{(100-(product.retail_price*100/product.price)).to_i}</discount>
      <recommendable>3 x 33.30</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category_humanize}</category>
      </product>
      </products>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end


    scenario "I want to see products of criteo" do
      visit criteo_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
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
      <discount>#{(100-(product.retail_price*100/product.price)).to_i}</discount>
      <recommendable><#{ build_installment_text(product.retail_price)}</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category_humanize}</category>
      </product>
      </products>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "in the mt_performance xml page" do
    context "when product is in stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(false)
      end

      scenario "I want to see products of mt_perfomance" do
        visit mt_performance_path
        result = Nokogiri::XML(page.source)
        content = <<-END.gsub(/^ {8}/, '')
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
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      end
    end

    context "when product is out of stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(true)
      end

      scenario "I see an empty XML" do
        visit mt_performance_path
        result = Nokogiri::XML(page.source)
        content = <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        </produtos>
        END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
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
        result = Nokogiri::XML(page.source)
        content = <<-END.gsub(/^ {8}/, '')
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
        <parcelamento><![CDATA[3 x 33.30]]></parcelamento>
        <imagens>
        </imagens>
        <num_tams>
        #{product.variants.map { |variant|
        '<num_tam><![CDATA[' + variant.description + ']]></num_tam>'}.join("\n")}
        </num_tams>
        </produto>
        </produtos>
        END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      end
    end

  context "in the topster xml page" do

    context "when product is in stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(false)
      end

      scenario "I want to see products of topster" do
      visit topster_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {8}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>
      <produto>
      <id_produto><![CDATA[#{product.id}]]></id_produto>
      <link_produto><![CDATA[http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=topster]]></link_produto>
      <nome_produto><![CDATA[#{product.name}]]></nome_produto>
      <marca><![CDATA[olook]]></marca>
      <categoria><![CDATA[#{Category.t(product.category)}]]></categoria>
      <cores><cor><![CDATA[#{ product.color_name}]]></cor></cores>
      <descricao><![CDATA[#{ product.description}]]></descricao>
      <preco_de><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.price, :precision => 2) }]]></preco_de>
      <preco_por><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.retail_price, :precision => 2)}]]></preco_por>
      <parcelamento><![CDATA[3 x 33.30]]></parcelamento>
      <imagens>
      </imagens>
      <num_tams>
      #{product.variants.map { |variant|
      '<num_tam><![CDATA[' + variant.description + ']]></num_tam>'}.join("\n")}
      </num_tams>
      </produto>
      </produtos>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      end
  end

  context "in the netaffiliation xml page" do
    scenario "I want to see products of netaffiliation" do
      visit netaffiliation_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <products>
      <product id="#{product.id}">
      <name>#{product.name}</name>
      <smallimage></smallimage>
      <bigimage></bigimage>
      <producturl>http://www.olook.com.br/produto/#{product.id}?utm_campaign=compradores&amp;utm_content=6691&amp;utm_medium=vitrine&amp;utm_source=net_affiliation</producturl>
      <description>#{product.description}</description>
      <price>#{number_with_precision(product.retail_price, precision: 2, separator: ",")}</price>
      <retailprice>#{number_with_precision(product.price, precision: 2, separator: ",")}</retailprice>
      <discount>#{(100-(product.retail_price*100/product.price)).to_i}</discount>
      <recommendable>#{build_installment_text(product.retail_price, separator: ",")}</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category_humanize}</category>
      </product>
      </products>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

context "in the ilove_ecommerce xml page" do
    scenario "I want to see products of ilove ecommerce" do
      visit ilove_ecommerce_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <produtos>
      <produto>
      <codigo>#{product.id}</codigo>
      <categoria>12</categoria>
      <link>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=ilove_ecommerce</link>
      <imagem></imagem>
      <nome_titulo>#{product.name}</nome_titulo>
      <descricao>#{product.description}</descricao>
      <preco_real>99.9</preco_real>
      <preco_desconto>99.9</preco_desconto>
      <specific>
      <marca>Olook</marca>
      <cor></cor>
      <tamanho></tamanho>
      <autor></autor>
      <artista></artista>
      <editora></editora>
      <ritmo></ritmo>
      <distribuidora></distribuidora>
      <sinopse></sinopse>
      <loja>Olook</loja>
      </specific>
      </produto>
      </produtos>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "in the shopping uol page " do
    scenario "I want to see products of shopping uol" do
      visit shopping_uol_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="iso-8859-1" ?>
      <produtos>
      <produto>
      <codigo>#{product.id}</codigo>
      <descricao>#{product.description}</descricao>
      <preco>99,90</preco>
      <nparcela>#{ build_installment_text(product.retail_price).chars.first }</nparcela>
      <vparcela>#{ build_installment_text(product.retail_price, separator: ",").split("x").last }</vparcela>
      <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=shopping_uol</url>
      <url_imagem></url_imagem>
      <Frete>Sim</Frete>
      <departamento></departamento>
      </produto>
      </produtos>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "in the google shopping" do
    scenario "I want to see products of google shopping" do
      visit google_shopping_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <products>
      <product>
      <id>#{product.id}</id>
      <title>#{product.name}</title>
      <description>#{product.description}</description>
      <category>Vestuário e acessórios &gt; Sapatos</category>
      <google_product_category>Vestuário e acessórios &gt; Sapatos</google_product_category>
      <product_type>#{product.category_humanize}</product_type>
      <link>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=google_shopping</link>
      <image_link>#{product.pictures.last.try(:image)}</image_link>
      <additional_image_link>#{product.pictures.first.try(:image)}</additional_image_link>
      <condition>new</condition>
      <price>#{product.price}</g:price>
      <sale_price>#{product.retail_price}</sale_price>
      <brand>Olook</brand>
      <gender>female</gender>
      <age_group>adult</age_group>
      #{product.variants.map { |variant|
      '<size>' + variant.display_reference + '</size>'}.join("\n")}
      <item_group_id>#{product.id}</item_group_id>
      <color>#{product.color_name}</color>
      <shipping>
      <country></country>
      <service></service>
      <price></price>
      </shipping>
      </product>
      </products>
    END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "in the buscape page " do
    scenario "I want to see products of buscape " do
      visit buscape_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="iso-8859-1" ?>
      <produtos>
      <produto>
        <descricao>#{ product.name }</descricao>
        <preco>#{ number_to_currency(product.price).delete("R$ ") }</preco>
        <id_produto>#{ product.id }</id_produto>
        <codigo_barra></codigo_barra>
        <isbn></isbn>
        <link_prod>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=buscape</link_prod>
        <imagem>#{ product.main_picture.try(:image) }</imagem>
        <categ>#{ product.category_humanize }</categ>
        <parcelamento>#{ build_installment_text(product.retail_price) }</parcelamento>
        <detalhes>#{ product.description }</detalhes>
      </produto>
      </produtos>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "in the sociomantic page " do
    scenario "I want to see products of sociomantic" do
      visit sociomantic_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <products xmlns="http://data-vocabular.org/product/">
      <product>
      <identifier>#{product.id}</identifier>
      <fn>#{product.name}</fn>
      <description>#{product.description}</description>
      <category>#{product.category}</category>
      <brand>Olook</brand>
      <price>#{product.retail_price}</price>
      <amount>#{product.price}</amount>
      <currency>BRL</currency>
      <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=banner&amp;utm_source=sociomantic</url>
      <photo>#{product.pictures.last.try(:image)}</photo>
      </product>
      </products>
      END
      equivalent_content = Nokogiri::XML(content)
      result.should be_equivalent_to(equivalent_content)
    end
  end

  end


    context "when product is out of stock" do
      before do
        Product.any_instance.stub(:sold_out?).and_return(true)
      end

      scenario "I see an empty XML" do
        visit click_a_porter_path
        result = Nokogiri::XML(page.source)
        content = <<-END.gsub(/^ {8}/, '')
        <?xml version="1.0" encoding="UTF-8"?>
        <produtos>
        </produtos>
        END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      end
    end

  end
end
