class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(9450, 10298, 10396, 10201, 9938)
    @products_didi = Product.find(9452, 8680, 9748, 9448, 8321)
  end
end
