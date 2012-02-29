class XmlController < ApplicationController
  respond_to :xml

  def show
    @products = Product.for_xml
    respond_with(@products, :skip_types => true)
  end

end
