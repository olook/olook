class SearchController < ApplicationController
  respond_to :json

  def index
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term]) if params[:term].length >= 3
  end

end
