class CriteoController < ApplicationController
  respond_to :xml

  def show
    #@products = Product.for_criteo
    @products = Product.all
    respond_with(@products, :skip_types => true)
  end

end
