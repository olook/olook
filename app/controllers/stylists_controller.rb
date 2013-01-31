class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(14367, 10400, 14846, 15084, 15162, 14814)
    @products_didi = Product.find(13830, 12003, 11069, 11606, 12043)
    @products_paola = Product.find(12425, 15074,14868, 13098, 13934, 15072)
  end
end
