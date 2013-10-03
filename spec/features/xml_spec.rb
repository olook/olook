# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'
include ActionView::Helpers::NumberHelper
include XmlHelper

  def stub_scope_params
    Product.should_receive(:xml_blacklist).with("products_blacklist").and_return([0])
  end

feature "Show products on xml format" do
  let!(:bag) { FactoryGirl.create :basic_bag }
  let!(:product) { FactoryGirl.create :blue_sliper_with_variants }

  background do
    product.master_variant.update_attribute(:price, "99.90")
    product.master_variant.update_attribute(:inventory, 1)
    stub_scope_params
  end

  context "on mt_performance" do
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
        <marca>OLOOK</marca>
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

  context "on click a porter" do
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
        <marca><![CDATA[OLOOK]]></marca>
        <categoria><![CDATA[#{Category.t(product.category)}]]></categoria>
        <cores><cor><![CDATA[#{ product.color_name}]]></cor></cores>
        <descricao><![CDATA[#{ product.description}]]></descricao>
        <preco_de><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.price, :precision => 2) }]]></preco_de>
        <preco_por><![CDATA[#{ ActionController::Base.helpers.number_with_precision(product.retail_price, :precision => 2)}]]></preco_por>
        <parcelamento><![CDATA[3 x 33.30]]></parcelamento>
        <imagens>
        <imagem>
        <![CDATA[]]>
        </imagem>
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
  end

  context "on netaffiliation" do
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
      <brand>OLOOK</brand>
      <recommendable>1</recommendable>
      <instock>#{product.instock}</instock>
      <category>#{product.category_humanize}</category>
      </product>
      </products>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "on ilove_ecommerce" do
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
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "on shopping uol" do
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
      <marca>OLOOK</marca>
      <url>http://www.olook.com.br/produto/#{product.id}?utm_campaign=Produtos&amp;utm_content=#{product.id}&amp;utm_medium=Remarketing&amp;utm_source=shopping_uol</url>
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

  context "on google shopping" do
    before do
      product.details << FactoryGirl.create(:shoe_with_metal)
      product.details << FactoryGirl.create(:sandalia)
      product.details << FactoryGirl.create(:shoe_with_leather)
      product.update_attribute(:producer_code, "1233123")
    end

    scenario "I want to see products" do
      visit google_shopping_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <rss xmlns:g="http://base.google.com/ns/1.0" version="2.0">
      <channel>
      <item>
      <g:id>#{product.id}</g:id>
      <title>#{product.subcategory} #{product.name}</title>
      <description>#{product.description}</description>
      <g:google_product_category>Vestuário e acessórios &gt; Sapatos</g:google_product_category>
      <g:product_type>#{product.subcategory}-#{product.brand.upcase}</g:product_type>
      <link>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=merchant&amp;utm_source=google</link>
      <g:image_link/>
      <g:additional_image_link/>
      <g:condition>new</g:condition>
      <g:price>#{number_with_precision(product.price, precision: 2, separator: ".")}</g:price>
      <g:sale_price>#{number_with_precision(product.retail_price, precision: 2, separator: ".")}</g:sale_price>
      <g:brand>OLOOK</g:brand>
      <g:gender>female</g:gender>
      <g:age_group>adult</g:age_group>
      #{product.variants.map { |variant|
      '<g:size>' + variant.display_reference + '</g:size>'}.join("\n")}
      <g:item_group_id>#{product.id}</g:item_group_id>
      <g:mpn>#{product.producer_code}</g:mpn>
      <g:color>#{ product.color_name }</g:color>
      <g:material>#{ product.details.first.description }</g:material>
      <g:material>#{ product.details.last.description }</g:material>
      </item>
      </channel>
      </rss>
    END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "on buscape" do
    before do
      product.details << FactoryGirl.create(:shoe_with_metal)
      product.details << FactoryGirl.create(:shoe_with_leather)
    end

    scenario "I want to see products of buscape " do
      visit buscape_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="iso-8859-1" ?>
      <produtos>
      <produto>
        <descricao>#{product.subcategory} #{product.name}</descricao>
        <preco>#{ number_to_currency(product.price).delete("R$ ") }</preco>
        <id_produto>#{ product.id }</id_produto>
        <marca>OLOOK</marca>
        <codigo_barra></codigo_barra>
        <isbn></isbn>
        <link_prod>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=vitrine&amp;utm_source=buscape</link_prod>
        <imagem>#{ product.main_picture.try(:image) }</imagem>
        <categ>#{ product.category_humanize }</categ>
        <parcelamento>#{ build_installment_text(product.retail_price) }</parcelamento>
        <detalhes>#{ product.description }</detalhes>
        <material>#{ product.details.first.description }</material>
        <material>#{ product.details.last.description }</material>
      </produto>
      </produtos>
      END
      equivalent_content = Nokogiri::XML(content)
      EquivalentXml.equivalent?(result, equivalent_content, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  context "on zanox" do
    scenario "I want to see products of zanox" do
      visit zanox_path
      result = Nokogiri::XML(page.source)
      content = <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8"?>
      <productos>
      <producto>
      <PROD_NUMBER>#{product.id}</PROD_NUMBER>
      <PROD_NAME>#{product.name}</PROD_NAME>
      <PROD_PRICE>#{product.retail_price}</PROD_PRICE>
      <PROD_PRICE_OLD>#{product.price}</PROD_PRICE_OLD>
      <CURRENCY_SIMBOL>BRL</CURRENCY_SIMBOL>
      <PROD_DESCRIPTION>#{product.description[0..512]}</PROD_DESCRIPTION>
      <PROD_DESCRIPTION_LONG>#{product.description}</PROD_DESCRIPTION_LONG>
      <PROD_URL>http://www.olook.com.br/produto/#{product.id}?utm_campaign=produtos&amp;utm_content=#{product.id}&amp;utm_medium=xml&amp;utm_source=zanox</PROD_URL>
      <BRAND>OLOOK</BRAND>
      <CATEGORY>#{product.category_humanize}</CATEGORY>
      <FOTO_URL>#{product.main_picture.try(:image)}</FOTO_URL>
      </producto>
      </productos>
      END
      equivalent_content = Nokogiri::XML(content)
      result.should be_equivalent_to(equivalent_content)
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
feature "Show products on xml format for topster" do
  pending
    context "when product is in stock" do
      before do
        pending "Usar VCR"
        #Product.any_instance.stub(:sold_out?).and_return(false)
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
end
