class LookbooksController < ApplicationController
  def flores
    @products = Product.find(493, 417, 435, 1, 563, 401, 403, 569)
  end

  def lets_party
    @products = Product.find(521, 539, 499)
  end

  def golden_grace
    @products = Product.find(136, 100, 163, 431, 449, 411, 459, 465, 563, 571, 405, 577, 401, 403, 569, 575, 561)
  end

  def color_block
    @products = Product.find(190, 217, 28, 425, 427, 491, 461, 481, 407, 397, 399)
  end
end
