class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(8267, 14784, 15748, 15025, 14792, 15750)
    @products_didi = Product.find(13830, 12003, 11069, 11606, 12043)
    @products_paola = Product.find(12425, 15074,14868, 13098, 13934, 15072)
  end
end
