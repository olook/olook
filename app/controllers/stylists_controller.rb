class StylistsController < ApplicationController
  def helena_linhares
    @products_helena = Product.find(9408, 7425, 9276, 8536, 7787, 8964)
    @products_didi = Product.find(9075, 7965)
  end
end
