class CriteoController < ApplicationController
  respond_to :xml

  def show
    @products = Product.only_visible
    respond_with(@products, :skip_types => true)
  end

end
