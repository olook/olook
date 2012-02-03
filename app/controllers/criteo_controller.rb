class CriteoController < ApplicationController
  respond_to :xml

  def show
    @products = Product.for_criteo
    respond_with(@products, :skip_types => true)
  end

end
