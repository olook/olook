class LookbooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_order

  def flores
    @products = Product.find(493, 495, 497, 413, 415, 417, 435, 433, 1, 563, 401, 403, 569)
  end
end
