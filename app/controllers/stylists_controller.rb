class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(7699)
    @products_didi = Product.find(7400, 7707, 7893, 7077, 7641, 6428)
  end
end
