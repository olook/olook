# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Show products on xml format" do
  let!(:variant) { FactoryGirl.create :variant, :price => 30.55, :id => "20" }

  context "in the product xml page" do
    scenario "I want to see products of criteo" do
      visit criteo_path
      debugger
      page.source.should == <<-END.gsub(/^ {6}/, '')
      <?xml version="1.0" encoding="UTF-8" ?>
      <products>
        <product id="#{variant.product.id}">
        <name>#{variant.product.name}</name>
        <smallimage></smallimage>
        <bigimage></bigimage>
        <producturl>http://www.olook.com.br/produto/#{variant.product.id}?utm_campaign=remessaging&amp;utm_content=#{variant.product.id}&amp;utm_medium=banner&amp;utm_source=criteo</producturl>
        <description>#{variant.product.description}</description>
        <price>#{variant.price}</price>
        <retailprice>#{variant.price}</retailprice>
        <recommendable>1</recommendable>
        <instock>#{variant.product.instock}</instock>
        <category>#{variant.product.category}</category>
        </product>
      </products>
      END
    end
  end
end
