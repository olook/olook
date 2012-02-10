class LookbooksController < ApplicationController
  def show
    if params[:name]
      @lookbook = Lookbook.where("name = '#{params[:name]}' and active = 1").order("created_at DESC")[0]
    else
      @lookbook = Lookbook.where("active = 1").order("created_at DESC").limit(1)[0]
    end
    @products = @lookbook.products
    @products_id = @lookbook.lookbooks_products.map{|item| ( item.criteo ) ? item.product_id : nil }.compact
    @lookbooks = Lookbook.order("created_at DESC")
  end

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

  def glitter
    @products = Product.find(271, 181)
  end

  def palha
    @products = Product.find(1499, 1501, 1453, 1511)
  end

  def sapatilhas
    @products = Product.find(1, 28, 181, 208, 19, 163, 199)
  end

  def safari
    @products = Product.find(1491, 1539, 1297, 1371, 1447, 1237, 1564, 787, 1075, 1339, 1564, 760, 696)
  end

  def vintage
    @products = Product.find(1156, 1219, 823, 976, 994, 877, 904, 751, 1395, 1379, 1387, 1481, 1491)
  end

  def fashion
    @products = Product.find(1138, 1075, 1048, 1405, 1529, 1385, 1413, 1447, 1477, 1497, 1539, 1545, 1564, 1120, 1066, 805)
  end

  def scarpin_glamour
    @products = Product.find(614, 623, 1491, 1543, 1021, 1219, 1433, 1369, 1642, 1651, 1660)
  end

  def militar
    @products = Product.find(1228, 778, 1479, 1165, 967, 1084, 787, 1429, 1329, 1387, 1381, 1566, 1495)
  end

  def verao
    @products = Product.find(796, 696, 814, 669, 751, 769, 904, 1129)
  end

  def candy_flavor
    @products = Product.find(64, 73, 949, 1582, 1626, 1765, 1598)
  end
end
