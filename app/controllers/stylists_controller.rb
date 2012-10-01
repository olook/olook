class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(9450, 10298, 10396, 10675, 9938)
    @products_didi = Product.find(9075, 7965, 7679, 9004, 9303)
  end
end
