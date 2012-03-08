class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js
  before_filter :load_products

  def show
    respond_with @products
  end

  def update
    respond_with @products
  end

  private

    def load_products
      liquidation_products = LiquidationProduct.arel_table

      @products = Product.joins(:liquidation_products).
                          where(liquidation_products["subcategory_name"].in(params[:subcategories]).
                          or(liquidation_products["shoe_size"].in(params[:shoe_sizes]).
                          or(liquidation_products["heel"].in(params[:heels])))).order('category asc').
                          paginate(:page => params[:page], :per_page => 15)

    end
end
