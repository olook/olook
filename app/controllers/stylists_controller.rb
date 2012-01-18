class StylistsController < ApplicationController
  def helena_linhares
    @products = Product.find(1147, 1383, 1545)
  end
end
