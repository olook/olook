class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(12389, 13722, 12035, 13493, 9061, 13870)
    @products_didi = Product.find(13830, 12003, 11069, 11606, 12043)
    @products_paola = Product.find(9117, 13924, 9460, 11749, 11977, 13584)
  end
end
