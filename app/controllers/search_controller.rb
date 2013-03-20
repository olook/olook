class SearchController < ApplicationController
  respond_to :json

  def index
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term])
  end

end
