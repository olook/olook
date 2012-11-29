class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(10486, 11961, 11273, 11626, 12230)
    @products_didi = Product.find(9452, 8680, 9748, 9448, 8321)
  end
end
