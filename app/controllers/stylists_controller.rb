class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(8608, 13608, 11985, 11971, 13199, 13268)
    @products_didi = Product.find(13191, 13253, 13205, 11993, 12311)
    @products_paola = Product.find(8554, 13638, 11981, 12275, 13229)
  end
end
