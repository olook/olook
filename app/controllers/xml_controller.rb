class XmlController < ApplicationController
  respond_to :xml
  before_filter :load_products, except: [:criteo]

  def sociomantic
    respond_with(@products)
  end

  def criteo
    @products = Product.valid_criteo_for_xml
    respond_with(@products)
  end

  def mt_performance
    respond_with(@products)
  end

  def click_a_porter
    respond_with(@products)
  end

  def topster
    respond_with(@products)
  end

  def netaffiliation
    respond_with(@products)
  end

  def shopping_uol
    respond_with(@products)
  end

  private

  def load_products
    @products = Product.valid_for_xml
  end

end
