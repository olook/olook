class XmlController < ApplicationController

  respond_to :xml
  before_filter :prepare_products, except: [:criteo, :groovinads]

  def sociomantic
    respond_with(@products)
  end

  def zanox
    respond_with(@products)
  end

  def criteo
    @products = Product.valid_criteo_for_xml(Product.xml_blacklist("products_blacklist"), Product.xml_blacklist("collections_blacklist"))
    respond_with(@products)
  end

  def groovinads
    liquidation_products
    remove_liquidation_products
    @products = Product.valid_criteo_for_xml(Product.xml_blacklist("products_blacklist"), Product.xml_blacklist("collections_blacklist"))
    respond_with(@products)
  end

  def mt_performance
    respond_with(@products)
  end

  def click_a_porter
    respond_with(@products)
  end

  def netaffiliation
    respond_with(@products)
  end

  def shopping_uol
    respond_with(@products)
  end

  def triggit
    respond_with(@products)
  end

  def google_shopping
    respond_with(@products)
  end

  def struq
    respond_with(@products)
  end

  private

    def prepare_products
      load_products
      liquidation_products
      remove_liquidation_products
    end

    def load_products
      @products = Product.valid_for_xml(Product.xml_blacklist("products_blacklist"), Product.xml_blacklist("collections_blacklist"))
    end

    def liquidation_products
      @liquidation_products = []
      active_liquidation = LiquidationService.active
      @liquidation_products = active_liquidation.resume[:products_ids] if active_liquidation
    end

    def remove_liquidation_products
      @products.delete_if{|product| @liquidation_products.include?(product.id)} if @products
    end

end
