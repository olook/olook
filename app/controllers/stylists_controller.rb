class StylistsController < ApplicationController
  before_filter :load_order

  def helena_linhares
    @products = Product.find(1147, 1383, 1545)
  end
end
