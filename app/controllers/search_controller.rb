class SearchController < ApplicationController
  respond_to :json

  def index

  end

  def show
    # url = "?q=#{params[:q]}&return-fields=categoria,name,description,text_relevance"
    url = URI.parse("http://busca.olook.com.br/2011-02-01/search?q=#{CGI.escape params[:q]}&return-fields=categoria,name,description,image,text_relevance")
    response = Net::HTTP.get_response(url)

    @hits = JSON.parse(response.body)["hits"]    
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

end
