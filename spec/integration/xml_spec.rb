# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Show products on xml format" do
  let!(:bag) { FactoryGirl.create :basic_bag }
  let!(:product) { FactoryGirl.create :basic_shoe }

  background do
    product.master_variant.update_attribute(:price, 1.0)
  end

  context "in the product xml page" do
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
end
