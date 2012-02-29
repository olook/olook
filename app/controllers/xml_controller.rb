class XmlController < ApplicationController
  respond_to :xml

  def criteo
    @products = Product.for_xml
    respond_with(@products)
  end

  def mt_perfomance
    @products = Product.all
    respond_with(@products)
  end

end
