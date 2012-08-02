class StylistsController < ApplicationController
  before_filter :load_order

  def helena_linhares
    @products_didi = Product.find(6391, 5591, 6463, 5894, 5627, 5777)
  end
end
