class LookbooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_order

  def flores
    @products = Product.find(493, 417, 435, 1, 563, 401, 403, 569)
  end

  def lets_party
    @products = Product.find(521, 530, 539, 548, 499)
  end
end
